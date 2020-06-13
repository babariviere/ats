defmodule AtsWeb.Resolvers.Jobs do
  @moduledoc """
  Resolver for jobs method.
  """

  alias Ats.Applicants.Job
  alias AtsWeb.Schema.Pagination

  @doc """
  Returns a list of all jobs.
  """
  def list_jobs(_root, args, _info) do
    query = Pagination.apply(Job, args)

    {:ok, Ats.Repo.all(query)}
  end

  @doc """
  Returns place from a job.
  """
  def place(root, _args, _info) do
    {lon, lat} = root.place.coordinates
    {:ok, %{longitude: lon, latitude: lat}}
  end
end
