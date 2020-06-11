defmodule Ats.Repo do
  use Ecto.Repo,
    otp_app: :ats,
    adapter: Ecto.Adapters.Postgres
end
