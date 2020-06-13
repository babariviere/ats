defmodule AtsWeb.Resolvers.Continents do
  @moduledoc """
  Resolver for continents method.
  """

  import Ecto.Query, only: [from: 2]

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
end
