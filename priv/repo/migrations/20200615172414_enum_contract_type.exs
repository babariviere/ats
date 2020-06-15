defmodule Ats.Repo.Migrations.EnumContractType do
  use Ecto.Migration

  def change do
    execute "UPDATE jobs SET contract_type = LOWER(contract_type)",
            "UPDATE jobs SET contract_type = UPPER(contract_type)"
  end
end
