defmodule AtsWeb.Schema.ProfessionTypes do
  @moduledoc """
  GraphQL types for Applicants.Profession.
  """
  use Absinthe.Schema.Notation

  alias AtsWeb.Resolvers
  import AtsWeb.Schema.Pagination, only: [pagination: 0]
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  object :profession do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :category_name, non_null(:string)

    @desc "Get all jobs with this profession"
    field :jobs, list_of(non_null(:job)), resolve: dataloader(Applicants)
  end

  object :profession_queries do
    @desc "List all professions."
    field :professions, list_of(non_null(:profession)) do
      pagination()
      resolve(&Resolvers.Professions.list_professions/3)
    end
  end
end
