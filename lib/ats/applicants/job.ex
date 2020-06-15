defmodule Ats.Applicants.Job do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias Ats.Applicants.Profession
  alias Ats.Applicants.ContractType

  schema "jobs" do
    field :contract_type, ContractType
    field :name, :string
    field :place, Geo.PostGIS.Geometry
    belongs_to :profession, Profession

    timestamps()
  end

  @doc false
  def changeset(job, attrs) do
    job
    |> cast(attrs, [:name, :contract_type, :place])
    |> validate_required([:name, :contract_type])
  end

  @doc """
  Apply Job.changeset/1 and changes to profession
  """
  def profession_changeset(job, attrs) do
    changeset(job, attrs)
    |> cast_assoc(:profession)
  end
end
