defmodule AtsWeb.Schema.JobsTest do
  use AtsWeb.ConnCase, async: true

  alias Ats.Applicants.Job
  alias Ats.Repo

  @jobs [
    %Job{
      id: 1,
      name: "A",
      contract_type: :full_time,
      place: %Geo.Point{coordinates: {48.855788, 2.338990}, srid: 4326}
    },
    %Job{
      id: 2,
      name: "B",
      contract_type: :full_time,
      # 0.5 km from Job A
      place: %Geo.Point{coordinates: {48.853517, 2.334300}, srid: 4326}
    },
    %Job{
      id: 3,
      name: "C",
      contract_type: :part_time,
      # 1.3 km from Job A
      # 0.75 km from Job B
      place: %Geo.Point{coordinates: {48.848400, 2.328240}, srid: 4326}
    }
  ]

  setup context do
    Enum.map(@jobs, &Repo.insert!/1)
    conn = plug_doc(context.conn, module: __MODULE__, action: :index)

    {:ok, %{context | conn: conn}}
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
      conn
      |> post("/api", %{
        "query" => query
      })
      |> doc("List all jobs")

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
      conn
      |> post("/api", %{
        "query" => query
      })
      |> doc("List all jobs with pagination")

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
      conn
      |> post("/api", %{
        "query" => query
      })
      |> doc("List all jobs near another job")

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
      conn
      |> post("/api", %{
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

  test "query: get a job", %{conn: conn} do
    query = """
    {
      job(id: "1") {
        name
      }
    }
    """

    conn =
      conn
      |> post("/api", %{
        "query" => query
      })
      |> doc("Get a single job")

    assert json_response(conn, 200) == %{
             "data" => %{
               "job" => %{"name" => "A"}
             }
           }
  end

  test "query: job not found", %{conn: conn} do
    query = """
    {
      job(id: "0") {
        name
      }
    }
    """

    conn =
      conn
      |> post("/api", %{
        "query" => query
      })
      |> doc("Get an inexistant job")

    assert json_response(conn, 200) == %{
             "data" => %{
               "job" => nil
             },
             "errors" => [
               %{
                 "locations" => [%{"column" => 3, "line" => 2}],
                 "message" => "Job with id 0 does not exists",
                 "path" => ["job"]
               }
             ]
           }
  end

  test "mutation: create a new job", %{conn: conn} do
    query = """
    mutation {
      createJob(name: "Test Job", contractType: FULL_TIME) {
        name
        contractType
      }
    }
    """

    conn =
      conn
      |> post("/api", %{
        "query" => query
      })
      |> doc("Create a new job")

    assert json_response(conn, 200) == %{
             "data" => %{
               "createJob" => %{
                 "name" => "Test Job",
                 "contractType" => "FULL_TIME"
               }
             }
           }
  end

  test "mutation: create a new job without name", %{conn: conn} do
    query = """
    mutation {
      createJob(contractType: FULL_TIME) {
        name
        contractType
      }
    }
    """

    conn =
      conn
      |> post("/api", %{
        "query" => query
      })
      |> doc("Create a new job without name")

    assert json_response(conn, 200) == %{
             "errors" => [
               %{
                 "locations" => [%{"column" => 3, "line" => 2}],
                 "message" => "In argument \"name\": Expected type \"String!\", found null."
               }
             ]
           }
  end

  test "mutation: create a new job without contract type", %{conn: conn} do
    query = """
    mutation {
      createJob(name: "Test Job") {
        name
        contractType
      }
    }
    """

    conn =
      conn
      |> post("/api", %{
        "query" => query
      })
      |> doc("Create a new job without contractType")

    assert json_response(conn, 200) == %{
             "errors" => [
               %{
                 "locations" => [%{"column" => 3, "line" => 2}],
                 "message" =>
                   "In argument \"contractType\": Expected type \"ContractType!\", found null."
               }
             ]
           }
  end

  describe "profession" do
    alias Ats.Applicants.Profession

    @job_with_profession %Job{
      id: 4,
      name: "D",
      contract_type: :part_time,
      place: %Geo.Point{coordinates: {0.0, 0.0}, srid: 4326},
      profession_id: 1
    }

    @profession %Profession{
      id: 1,
      name: "A",
      category_name: "Tech"
    }

    setup do
      Repo.insert!(@profession)
      Repo.insert!(@job_with_profession)
      :ok
    end

    test "query: get a job's profession", %{conn: conn} do
      query = """
      {
        job(id: "4") {
          name
          profession {
            categoryName
          }
        }
      }
      """

      conn =
        conn
        |> post("/api", %{
          "query" => query
        })
        |> doc("Get a job's profession")

      assert json_response(conn, 200) == %{
               "data" => %{
                 "job" => %{"name" => "D", "profession" => %{"categoryName" => "Tech"}}
               }
             }
    end
  end
end
