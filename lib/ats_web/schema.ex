defmodule AtsWeb.Schema do
  @moduledoc """
  GraphQL Schema for ATS.
  """
  use Absinthe.Schema

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias AtsWeb.Resolvers
  alias Ats.Applicants
  import AtsWeb.Schema.Pagination

  def context(ctx) do
    loader =
      Dataloader.new()
      |> Dataloader.add_source(Applicants, Applicants.data())

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end

  object :continent do
    field :id, non_null(:id)
    field :name, non_null(:string)
  end

  object :profession do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :category_name, non_null(:string)

    field :jobs, list_of(non_null(:job)), resolve: dataloader(Applicants)
  end

  object :point do
    field :longitude, :float
    field :latitude, :float
  end

  object :job do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :contract_type, non_null(:string)

    field :profession, :profession do
      resolve(dataloader(Applicants))
    end

    field :place, :point do
      resolve(&Resolvers.Jobs.place/3)
    end
  end

  query do
    field :continents, list_of(non_null(:continent)) do
      pagination()
      resolve(&Resolvers.Continents.list_continents/3)
    end

    field :professions, list_of(non_null(:profession)) do
      pagination()
      resolve(&Resolvers.Professions.list_professions/3)
    end

    field :jobs, list_of(non_null(:job)) do
      pagination()
      resolve(&Resolvers.Jobs.list_jobs/3)
    end
  end
end
