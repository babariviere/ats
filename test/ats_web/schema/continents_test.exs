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

  test "query: get a continent", %{conn: conn} do
    query = """
    {
      continent(id: "1") {
        name
      }
    }
    """

    conn =
      conn
      |> post("/api", %{
        "query" => query
      })
      |> doc("Get a single continent")

    assert json_response(conn, 200) == %{
             "data" => %{
               "continent" => %{"name" => "Europe"}
             }
           }
  end

  test "query: continent not found", %{conn: conn} do
    query = """
    {
      continent(id: "0") {
        name
      }
    }
    """

    conn =
      conn
      |> post("/api", %{
        "query" => query
      })
      |> doc("Get an inexistant continent")

    assert json_response(conn, 200) == %{
             "data" => %{
               "continent" => nil
             },
             "errors" => [
               %{
                 "locations" => [%{"column" => 3, "line" => 2}],
                 "message" => "Continent with id 0 does not exists",
                 "path" => ["continent"]
               }
             ]
           }
  end

  describe "jobs" do
    @jobs [
      %{
        name: "A",
        contract_type: :full_time,
        place: %Geo.Point{coordinates: {1.0, 1.0}, srid: 4326}
      },
      %{
        name: "B",
        contract_type: :full_time,
        place: %Geo.Point{coordinates: {1.0, 50.0}, srid: 4326}
      },
      %{
        name: "C",
        contract_type: :full_time,
        place: %Geo.Point{coordinates: {1.0, 10.0}, srid: 4326}
      },
      %{
        name: "D",
        contract_type: :full_time,
        place: %Geo.Point{coordinates: {-1.0, -1.0}, srid: 4326}
      },
      %{
        name: "E",
        contract_type: :full_time,
        place: %Geo.Point{coordinates: {-1.0, -50.0}, srid: 4326}
      },
      %{
        name: "F",
        contract_type: :full_time,
        place: %Geo.Point{coordinates: {-1.0, -10.0}, srid: 4326}
      }
    ]

    setup do
      Enum.map(@jobs, &Ats.Applicants.create_job/1)
      :ok
    end

    test "query: get jobs in continents", %{conn: conn} do
      query = """
      {
        continent(id: "1") {
          jobs {
            name
          }
        }
      }
      """

      conn =
        conn
        |> post("/api", %{
          "query" => query
        })
        |> doc("List jobs in continent")

      assert json_response(conn, 200) == %{
               "data" => %{
                 "continent" => %{
                   "jobs" => [
                     %{"name" => "A"},
                     %{"name" => "B"},
                     %{"name" => "C"}
                   ]
                 }
               }
             }
    end
  end
end
