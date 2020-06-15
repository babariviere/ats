defmodule AtsWeb.Schema.ContinentTypes do
  @moduledoc """
  GraphQL types for Applicants.Continent.
  """
  use Absinthe.Schema.Notation

  alias AtsWeb.Resolvers
  import AtsWeb.Schema.Pagination, only: [pagination: 0]

  object :continent do
    field :id, non_null(:id)
    field :name, non_null(:string)
  end

  object :continent_queries do
    @desc "List all continents."
    field :continents, list_of(non_null(:continent)) do
      pagination()
      resolve(&Resolvers.Continents.list_continents/3)
    end
  end
end
