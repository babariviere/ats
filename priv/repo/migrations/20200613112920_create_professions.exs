defmodule Ats.Repo.Migrations.CreateProfessions do
  use Ecto.Migration

  def change do
    create table(:professions) do
      add :name, :string, null: false
      add :category_name, :string, null: false
    end

    create unique_index(:professions, :name)
  end
end
