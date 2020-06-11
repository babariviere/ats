defmodule Ats.World.Continent do
  @moduledoc """
  A continent delimited by a GeoJSON MultiPolygon shape
  as described in the RFC (https://tools.ietf.org/html/rfc7946#section-3.1.7).
  """

  defstruct [:shape, :name]

  @type t() :: %__MODULE__{
          name: charlist(),
          shape: Geo.MultiPolygon.t()
        }
end
