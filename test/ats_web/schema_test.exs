defmodule AtsWeb.SchemaTest do
  use AtsWeb.ConnCase, async: true

  describe "jobs" do
    alias Ats.Applicants.Job
    alias Ats.Repo

    @jobs [
      %Job{
        id: 1,
        name: "A",
        contract_type: "FULL_TIME",
        place: %Geo.Point{coordinates: {48.855788, 2.338990}, srid: 4326}
      },
      %Job{
        id: 2,
        name: "B",
        contract_type: "FULL_TIME",
        # 0.5 km from Job A
        place: %Geo.Point{coordinates: {48.853517, 2.334300}, srid: 4326}
      },
      %Job{
        id: 3,
        name: "C",
        contract_type: "PART_TIME",
        # 1.3 km from Job A
        # 0.75 km from Job B
        place: %Geo.Point{coordinates: {48.848400, 2.328240}, srid: 4326}
      }
    ]

    setup do
      Enum.map(@jobs, &Repo.insert!/1)
      :ok
    end

    test "query: jobs names", %{conn: conn} do
      query = """
      {
        jobs {
          name
        }
      }
      """

      conn =
        post(conn, "/api", %{
          "query" => query
        })

      assert json_response(conn, 200) == %{
               "data" => %{
                 "jobs" => [
                   %{"name" => "A"},
                   %{"name" => "B"},
                   %{"name" => "C"}
                 ]
               }
             }
    end

    test "query: jobs pagination", %{conn: conn} do
      query = """
      {
        jobs(first: 2, offset: 1) {
          name
        }
      }
      """

      conn =
        post(conn, "/api", %{
          "query" => query
        })

      assert json_response(conn, 200) == %{
               "data" => %{
                 "jobs" => [
                   %{"name" => "B"},
                   %{"name" => "C"}
                 ]
               }
             }
    end

    test "query: jobs near A (1 km)", %{conn: conn} do
      query = """
      {
        job(id: "1") {
          place {
            near(radius: 1) {
              name
            }
          }
        }
      }
      """

      conn =
        post(conn, "/api", %{
          "query" => query
        })

      assert json_response(conn, 200) == %{
               "data" => %{
                 "job" => %{
                   "place" => %{
                     "near" => [%{"name" => "B"}]
                   }
                 }
               }
             }
    end

    test "query: jobs near A (2 km)", %{conn: conn} do
      query = """
      {
        job(id: "1") {
          place {
            near(radius: 2) {
              name
            }
          }
        }
      }
      """

      conn =
        post(conn, "/api", %{
          "query" => query
        })

      assert json_response(conn, 200) == %{
               "data" => %{
                 "job" => %{
                   "place" => %{
                     "near" => [%{"name" => "B"}, %{"name" => "C"}]
                   }
                 }
               }
             }
    end
  end
end
