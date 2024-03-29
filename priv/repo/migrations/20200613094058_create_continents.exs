defmodule Ats.Repo.Migrations.CreateContinents do
  use Ecto.Migration

  def change do
    create table(:continents) do
      add :name, :string, null: false
      add :shape, :geometry, null: false
    end

    create unique_index(:continents, :name)
  end
end
