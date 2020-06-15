defmodule AtsWeb.Schema.JobTypes do
  @moduledoc """
  GraphQL types for Applicants.Job.
  """
  use Absinthe.Schema.Notation

  alias AtsWeb.Resolvers
  import AtsWeb.Schema.Pagination, only: [pagination: 0]
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias Ats.Applicants

  @desc "Different contract types that a job accepts"
  enum :contract_type do
    value(:vie)
    value(:apprenticeship)
    value(:freelance)
    value(:full_time)
    value(:internship)
    value(:part_time)
    value(:temporary)
  end

  @desc "A job posted by an employer"
  object :job do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :contract_type, non_null(:contract_type)

    @desc "Get job's associated profession"
    field :profession, :profession do
      resolve(dataloader(Applicants))
    end

    @desc "Job's office place"
    field :place, :point do
      resolve(&Resolvers.Jobs.place/3)
    end
  end

  object :job_queries do
    @desc "Get a job."
    field :job, :job do
      arg(:id, :id)
      resolve(&Resolvers.Jobs.get_job/3)
    end

    @desc "List all jobs."
    field :jobs, list_of(non_null(:job)) do
      pagination()
      resolve(&Resolvers.Jobs.list_jobs/3)
    end
  end
end
