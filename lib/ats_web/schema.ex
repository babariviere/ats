defmodule AtsWeb.Schema do
  @moduledoc """
  GraphQL Schema for ATS.
  """
  use Absinthe.Schema

  alias AtsWeb.ContinentsResolver

  object :continent do
    field :id, non_null(:id)
    field :name, non_null(:string)
  end

  query do
    field :continents, non_null(list_of(non_null(:continent))) do
      resolve(&ContinentsResolver.all_continents/3)
    end
  end
end
