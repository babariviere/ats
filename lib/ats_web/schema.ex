defmodule AtsWeb.Schema do
  @moduledoc """
  GraphQL Schema for ATS.
  """
  use Absinthe.Schema

  alias Ats.Applicants
  alias AtsWeb.Resolvers

  def context(ctx) do
    loader =
      Dataloader.new()
      |> Dataloader.add_source(Applicants, Applicants.data())

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end

  import_types(AtsWeb.Schema.JobTypes)
  import_types(AtsWeb.Schema.ProfessionTypes)
  import_types(AtsWeb.Schema.ContinentTypes)

  input_object :input_point do
    field :longitude, non_null(:float)
    field :latitude, non_null(:float)
  end

  @desc "A geographic point"
  object :point do
    field :longitude, non_null(:float)
    field :latitude, non_null(:float)

    @desc "Get a list of jobs near this point. All jobs at this point will be excluded."
    field :near, list_of(non_null(:job)) do
      arg(:radius, non_null(:integer), description: "Radius in km")
      resolve(&Resolvers.Jobs.list_jobs_near/3)
    end
  end

  query do
    import_fields(:job_queries)
    import_fields(:profession_queries)
    import_fields(:continent_queries)

    @desc "Create a point to make geographical queries."
    field :point, :point do
      arg(:longitude, non_null(:float))
      arg(:latitude, non_null(:float))

      resolve(fn _, args, _ ->
        {:ok, args}
      end)
    end
  end

  mutation do
    import_fields(:job_mutations)
  end
end
