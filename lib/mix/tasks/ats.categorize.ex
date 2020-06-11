defmodule Mix.Tasks.Ats.Categorize do
  use Mix.Task

  alias NimbleCSV.RFC4180, as: CSV

  @moduledoc """
  #{@shortdoc}.

  It expects the path of two CSV files. The first one is the jobs dataset
  and the second one is the professions dataset.

      mix ats.categorize JOBS_PATH PROFESSIONS_PATH

  The output is a table where the column is the job category and the row
  is the continent.

  Jobs dataset must be a CSV file with the following headers:

      profession_id,contract_type,name,office_latitude,office_longitude

  Professions dataset must be a CSV file with the following headers:

      id,name,category_name


  ## Examples

      mix ats.categorize technical-test-jobs.csv technical-test-professions.csv

  Would generate the following table:

      TODO
  """

  # TODO: handle invalid jobs or profession file
  # TODO: add continents option

  @shortdoc "Categorize offers per continent"
  @impl Mix.Task
  def run([jobs_path, professions_path]) do
    # TODO: parse continents option
    continents = parse_continents()
    categories = parse_categories(professions_path)

    # What we need:
    # - total of categories
    # - total of continents
    # - total of categories per continents
    #
    # %{
    #   total_categories: 123,
    #   total_continents: 123,
    #   categories: %{
    #
    #   }
    # }

    result =
      parse_jobs(jobs_path)
      |> Flow.from_enumerable()
      |> Flow.flat_map(fn job ->
        category = categories[job.profession_id]

        # hd(continents)
        continent =
          Enum.find(continents, fn continent -> Topo.contains?(continent.shape, job.point) end)

        if continent == nil do
          []
        else
          [{continent.name, category}]
        end
      end)
      |> Flow.partition(key: {:elem, 0})
      |> Flow.reduce(fn -> %{} end, fn {continent, category}, acc ->
        update_in(acc, [Access.key(continent, %{}), Access.key(category, 0)], &(&1 + 1))
      end)
      |> Enum.sort_by(&elem(&1, 0), :asc)
      |> Enum.to_list()

    # TODO: merge categories with same name
    #
    category_names = categories |> Enum.map(fn {_, name} -> name end) |> Enum.uniq()

    # TODO: note to improve -> use GeoRust
    header = ["", "Total" | category_names]
    # 1. Total
    # 2. For each category
    #   a. For each continent
    #   b. ++
    total =
      Enum.reduce(result, 0, fn {_, cont}, acc ->
        acc + Enum.reduce(cont, 0, fn {_, v}, acc -> acc + v end)
      end)

    total_per_category =
      Enum.map(category_names, fn cat ->
        Enum.reduce(result, 0, fn {_, cont}, acc ->
          Map.get(cont, cat, 0) + acc
        end)
      end)

    first_row = ["Total", total | total_per_category]

    TableRex.quick_render!(
      [first_row | Enum.map(result, &convert_row(&1, category_names))],
      header
    )
    |> IO.puts()
  end

  def run(_args) do
    Mix.raise("""
    Invalid arguments, expected: mix ats.categorize <jobs_path> <professions_path>

    ## Examples

        mix ats.categorize technical-test-jobs.csv technical-test-professions.csv
    """)
  end

  def convert_row({continent, categories}, category_names) do
    total = Enum.reduce(categories, 0, fn {_, v}, acc -> v + acc end)

    category_results =
      Enum.map(category_names, fn name ->
        Map.get(categories, name, 0)
      end)

    [continent, total | category_results]
  end

  def parse_continents() do
    json =
      "priv/data/continents_low.geojson"
      |> File.read!()
      |> Jason.decode!()

    json["features"]
    |> Enum.map(fn feature ->
      {:ok, shape} =
        feature["geometry"]
        |> Geo.JSON.decode()

      name = feature["properties"]["continent"]

      %Ats.World.Continent{name: name, shape: shape}
    end)
  end

  # Parse categories by profession id
  defp parse_categories(path) do
    path
    |> File.stream!(read_ahead: 100_000)
    |> CSV.parse_stream()
    |> Stream.flat_map(fn [id, _name, category_name] ->
      id =
        case Integer.parse(id) do
          {id, _} -> id
          :error -> nil
        end

      if id != nil do
        [{id, category_name}]
      else
        []
      end
    end)
    |> Enum.reduce(%{}, fn {id, category}, acc ->
      Map.put(acc, id, category)
    end)
  end

  # Return a stream of [:profession_id, :point]
  def parse_jobs(path) do
    path
    |> File.stream!(read_ahead: 100_000)
    |> CSV.parse_stream()
    |> Stream.flat_map(fn [profession_id, _ct, _name, lat, lon] ->
      profession_id =
        case Integer.parse(profession_id) do
          {p, _} -> p
          :error -> nil
        end

      lat =
        case Float.parse(lat) do
          {l, _} -> l
          :error -> nil
        end

      lon =
        case Float.parse(lon) do
          {l, _} -> l
          :error -> nil
        end

      if profession_id && lon && lat do
        [%{profession_id: profession_id, point: %Geo.Point{coordinates: {lon, lat}}}]
      else
        []
      end
    end)
  end
end
