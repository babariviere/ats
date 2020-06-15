defmodule AtsWeb.Resolvers.Continents do
  @moduledoc """
  Resolver for continents method.
  """

  import Ecto.Query, only: [from: 2]
  import Geo.PostGIS

  alias Ats.Applicants.Job
  alias Ats.World.Continent
  alias Ats.Repo
  alias AtsWeb.Schema.Pagination

  @doc """
  Returns a list of all continents.
  """
  def list_continents(_root, args, _info) do
    query =
      from c in Continent,
        select: [:id, :name]

    query = Pagination.apply(query, args)

    continents = Repo.all(query)

    {:ok, continents}
  end

  @doc """
  Returns a single continent by it's id.
  """
  def get_continent(_root, %{id: id}, _info) do
    query = from j in Continent, where: j.id == ^id

    case Repo.one(query) do
      nil -> {:error, "Continent with id #{id} does not exists"}
      continent -> {:ok, continent}
    end
  end

  @doc """
  Returns a list jobs from continent.
  """
  # TODO: use dataloader instead ?
  # There is not a lot of continent but the query is heavy.
  def list_jobs(root, args, _info) do
    query =
      from j in Job,
        join: c in Continent,
        on: c.id == ^root.id,
        where: st_within(j.place, c.shape),
        select: j

    query = Pagination.apply(query, args)

    continents = Repo.all(query)

    {:ok, continents}
  end
end
