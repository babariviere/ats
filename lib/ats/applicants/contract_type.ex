defmodule Ats.Applicants.ContractType do
  @moduledoc """
  Job contract type enum for Ecto.
  """

  use EctoEnum.Postgres,
    type: :contract_type,
    enums: [
      :vie,
      :apprenticeship,
      :freelance,
      :full_time,
      :internship,
      :part_time,
      :temporary
    ]
end
