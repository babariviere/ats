defmodule AtsWeb.ContinentsResolver do
  @moduledoc """
  Resolver for continents method.
  """

  alias Ats.World.Continent

  import Ecto.Query, only: [from: 2]

  @doc """
  Returns a list of all continents.
  """
  def all_continents(_root, _args, _info) do
    query =
      from c in Continent,
        select: [:id, :name]

    continents = Ats.Repo.all(query)

    {:ok, continents}
  end
end
