defmodule AtsWeb.Schema.ContinentsTest do
  use AtsWeb.ConnCase, async: true

  alias Ats.World.Continent
  alias Ats.Repo

  @square %Geo.MultiPolygon{
    coordinates: [[[{0.0, 0.0}, {0.0, 100.0}, {100.0, 100.0}, {100.0, 0.0}, {0.0, 0.0}]]],
    srid: 4326
  }

  @continents [
    %Continent{
      id: 1,
      name: "Europe",
      shape: @square
    },
    %Continent{
      id: 2,
      name: "Africa",
      shape: @square
    },
    %Continent{
      id: 3,
      name: "South America",
      shape: @square
    }
  ]

  setup context do
    Enum.map(@continents, &Repo.insert!/1)
    conn = plug_doc(context.conn, module: __MODULE__, action: :index)

    {:ok, %{context | conn: conn}}
  end

  test "query: continents names", %{conn: conn} do
    query = """
    {
      continents {
        name
      }
    }
    """

    conn =
      conn
      |> post("/api", %{
        "query" => query
      })
      |> doc("List all continents")

    assert json_response(conn, 200) == %{
             "data" => %{
               "continents" => [
                 %{"name" => "Europe"},
                 %{"name" => "Africa"},
                 %{"name" => "South America"}
               ]
             }
           }
  end

  test "query: continents pagination", %{conn: conn} do
    query = """
    {
      continents(first: 2, offset: 1) {
        name
      }
    }
    """

    conn =
      conn
      |> post("/api", %{
        "query" => query
      })
      |> doc("List all continents with pagination")

    assert json_response(conn, 200) == %{
             "data" => %{
               "continents" => [
                 %{"name" => "Africa"},
                 %{"name" => "South America"}
               ]
             }
           }
  end
end
