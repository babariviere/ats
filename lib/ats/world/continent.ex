defmodule Ats.World.Continent do
  @moduledoc """
  A continent delimited by a GeoJSON MultiPolygon shape
  as described in the RFC (https://tools.ietf.org/html/rfc7946#section-3.1.7).
  """

  use Ecto.Schema
  import Ecto.Changeset

  @type t() :: %__MODULE__{
          name: charlist(),
          shape: Geo.MultiPolygon.t()
        }

  schema "continents" do
    field :name, :string
    field :shape, Geo.PostGIS.Geometry
  end

  @doc false
  def changeset(continent, attrs) do
    continent
    |> cast(attrs, [:name, :shape])
    |> validate_required([:name, :shape])
    |> unique_constraint(:name)
    |> validate_shape()
  end

  defp validate_shape(changeset) do
    case get_field(changeset, :shape) do
      %Geo.MultiPolygon{} -> changeset
      _ -> add_error(changeset, :shape, "invalid shape, expected a multi polygon")
    end
  end
end
