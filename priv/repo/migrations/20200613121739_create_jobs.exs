defmodule Ats.Repo.Migrations.CreateJobs do
  use Ecto.Migration

  def change do
    create table(:jobs) do
      add :name, :string, null: false
      add :contract_type, :string, null: false
      add :profession_id, references(:professions, on_delete: :nothing)
      add :place, :geometry

      timestamps()
    end

    create index(:jobs, [:profession_id])
  end
end
