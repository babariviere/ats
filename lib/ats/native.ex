defmodule Ats.Native do
  @moduledoc """
  Native functions written in Rust to improve performance for calculations heavy tasks.
  """
  use Rustler, otp_app: :ats, crate: :ats

  @type point_t() :: {float(), float()}
  @type geoline_t() :: list(point_t())
  @type polygon_t() :: list(geoline_t())
  @type multi_polygon_t() :: list(polygon_t())

  @type native_multi_polygon() :: any()

  @doc "Creates a new multi polygon to be used with multi_polygon_contains?/2"
  @spec multi_polygon(multi_polygon_t()) :: native_multi_polygon()
  def multi_polygon(_coordinates), do: :erlang.nif_error(:nif_not_loaded)
  @spec multi_polygon_contains?(native_multi_polygon(), point_t()) :: boolean()
  def multi_polygon_contains?(_shape, _point), do: :erlang.nif_error(:nif_not_loaded)
end
