defmodule Ats.Native do
  use Rustler, otp_app: :ats, crate: :ats

  def shape_contains?(_shape, _point), do: :erlang.nif_error(:nif_not_loaded)
end
