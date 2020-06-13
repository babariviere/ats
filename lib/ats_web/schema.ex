defmodule AtsWeb.Schema do
  @moduledoc """
  GraphQL Schema for ATS.
  """
  use Absinthe.Schema

  alias AtsWeb.ContinentsResolver
  alias AtsWeb.ProfessionsResolver

  object :continent do
    field :id, non_null(:id)
    field :name, non_null(:string)
  end

  object :profession do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :category_name, non_null(:string)
  end

  query do
    field :continents, non_null(list_of(non_null(:continent))) do
      resolve(&ContinentsResolver.all_continents/3)
    end

    field :professions, non_null(list_of(non_null(:profession))) do
      resolve(&ProfessionsResolver.all_professions/3)
    end
  end
end
