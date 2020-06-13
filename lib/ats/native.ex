defmodule Ats.Native do
  @moduledoc """
  Native functions written in Rust to improve performance for calculations heavy tasks.
  """
  use Rustler, otp_app: :ats, crate: :ats

  def continent_new(_shape), do: :erlang.nif_error(:nif_not_loaded)
  def shape_contains?(_shape, _point), do: :erlang.nif_error(:nif_not_loaded)
end
