defmodule Ats.Applicants.Profession do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ats.Applicants.Job

  schema "professions" do
    field :category_name, :string
    field :name, :string

    has_many :jobs, Job, foreign_key: :profession_id
  end

  @doc false
  def changeset(profession, attrs) do
    profession
    |> cast(attrs, [:name, :category_name])
    |> validate_required([:name, :category_name])
    |> unique_constraint(:name)
  end
end
