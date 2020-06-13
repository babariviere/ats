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

  @desc "A geographic point"
  object :point do
    field :longitude, non_null(:float)
    field :latitude, non_null(:float)
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
    @desc "List all continents."
    field :continents, list_of(non_null(:continent)) do
      pagination()
      resolve(&Resolvers.Continents.list_continents/3)
    end

    @desc "List all professions."
    field :professions, list_of(non_null(:profession)) do
      pagination()
      resolve(&Resolvers.Professions.list_professions/3)
    end

    @desc "List all jobs."
    field :jobs, list_of(non_null(:job)) do
      pagination()
      resolve(&Resolvers.Jobs.list_jobs/3)
    end

    @desc "Create a point to make geographical queries."
    field :point, :point do
      arg(:longitude, non_null(:float))
      arg(:latitude, non_null(:float))

      resolve(fn _, args, _ ->
        {:ok, args}
      end)
    end
  end
end
