defmodule AtsWeb.Resolvers.Professions do
  @moduledoc """
  Resolver for professions method.
  """

  alias Ats.Repo
  alias Ats.Applicants.Profession
  alias AtsWeb.Schema.Pagination

  @doc """
  Returns a list of all professions.
  """
  def list_professions(_root, args, _info) do
    query = Pagination.apply(Profession, args)

    {:ok, Repo.all(query)}
  end
end
