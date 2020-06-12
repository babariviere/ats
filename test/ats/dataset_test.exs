defmodule Ats.DatasetTest do
  use ExUnit.Case
  doctest Ats.Dataset

  import Ats.Dataset

  @square %Ats.World.Continent{
    name: "Square",
    shape: %Geo.Polygon{
      coordinates: [[{0.0, 0.0}, {0.0, 100.0}, {100.0, 100.0}, {100.0, 0.0}, {0.0, 0.0}]]
    }
  }
  @neg_square %Ats.World.Continent{
    name: "Neg Square",
    shape: %Geo.Polygon{
      coordinates: [[{0.0, 0.0}, {0.0, -100.0}, {-100.0, -100.0}, {-100.0, 0.0}, {0.0, 0.0}]]
    }
  }

  @jobs [
    %{profession_id: 1, office_latitude: 1.0, office_longitude: 1.0},
    %{profession_id: 1, office_latitude: 50.0, office_longitude: 1.0},
    %{profession_id: 2, office_latitude: 10.0, office_longitude: 1.0},
    %{profession_id: 1, office_latitude: -1.0, office_longitude: -1.0},
    %{profession_id: 2, office_latitude: -50.0, office_longitude: -1.0},
    %{profession_id: 2, office_latitude: -10.0, office_longitude: -1.0}
  ]

  @categories %{1 => "Positive", 2 => "Negative"}

  test "categories per continent" do
    result = categories_per_continent(@jobs, [@square, @neg_square], @categories)

    expect = [
      {"Neg Square",
       %{
         "Positive" => 1,
         "Negative" => 2
       }},
      {"Square",
       %{
         "Positive" => 2,
         "Negative" => 1
       }}
    ]

    assert result == expect
  end
end
