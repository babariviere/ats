defmodule AtsWeb.Resolvers.Jobs do
  @moduledoc """
  Resolver for jobs method.
  """

  import Ecto.Query, only: [from: 2]
  import Geo.PostGIS

  alias Ats.Applicants
  alias Ats.Applicants.Job
  alias Ats.Repo
  alias AtsWeb.Schema.Pagination

  @doc """
  Returns a list of all jobs.
  """
  def list_jobs(_root, args, _info) do
    query =
      from j in Job,
        order_by: j.id

    query = Pagination.apply(query, args)

    {:ok, Repo.all(query)}
  end

  @doc """
  Returns a list of all jobs near a point.
  """
  def list_jobs_near(%{longitude: lon, latitude: lat}, %{radius: radius}, _info) do
    # m -> km
    radius = 1000 * radius

    query =
      from j in Job,
        where:
          not st_equals(j.place, st_set_srid(st_point(^lon, ^lat), 4326)) and
            st_dwithin_in_meters(j.place, st_point(^lon, ^lat), ^radius),
        order_by: st_distance(j.place, st_set_srid(st_point(^lon, ^lat), 4326))

    {:ok, Repo.all(query)}
  end

  @doc """
  Returns a single job by it's id.
  """
  def get_job(_root, %{id: id}, _info) do
    query = from j in Job, where: j.id == ^id

    case Repo.one(query) do
      nil -> {:error, "Job with id #{id} does not exists"}
      job -> {:ok, job}
    end
  end

  @doc """
  Creates a new job.

  Note: there is no authorization as it is a toy project
  """
  def create_job(_root, args, _info) do
    Applicants.create_job(args)
  end

  @doc """
  Returns place from a job.
  """
  def place(root, _args, _info) do
    {lon, lat} = root.place.coordinates
    {:ok, %{longitude: lon, latitude: lat}}
  end
end
