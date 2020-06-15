defmodule AtsWeb.Schema.ProfessionsTest do
  use AtsWeb.ConnCase, async: true

  alias Ats.Applicants.Profession
  alias Ats.Repo

  @professions [
    %Profession{
      id: 1,
      name: "A",
      category_name: "Tech"
    },
    %Profession{
      id: 2,
      name: "B",
      category_name: "Tech"
    },
    %Profession{
      id: 3,
      name: "C",
      category_name: "Business"
    }
  ]

  setup context do
    Enum.map(@professions, &Repo.insert!/1)
    conn = plug_doc(context.conn, module: __MODULE__, action: :index)

    {:ok, %{context | conn: conn}}
  end

  test "query: professions names", %{conn: conn} do
    query = """
    {
      professions {
        name
        categoryName
      }
    }
    """

    conn =
      conn
      |> post("/api", %{
        "query" => query
      })
      |> doc("List all professions")

    assert json_response(conn, 200) == %{
             "data" => %{
               "professions" => [
                 %{"name" => "A", "categoryName" => "Tech"},
                 %{"name" => "B", "categoryName" => "Tech"},
                 %{"name" => "C", "categoryName" => "Business"}
               ]
             }
           }
  end

  test "query: professions pagination", %{conn: conn} do
    query = """
    {
      professions(first: 2, offset: 1) {
        name
      }
    }
    """

    conn =
      conn
      |> post("/api", %{
        "query" => query
      })
      |> doc("List all professions with pagination")

    assert json_response(conn, 200) == %{
             "data" => %{
               "professions" => [
                 %{"name" => "B"},
                 %{"name" => "C"}
               ]
             }
           }
  end
end
