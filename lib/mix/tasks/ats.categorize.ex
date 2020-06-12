defmodule Mix.Tasks.Ats.Categorize do
  use Mix.Task

  alias Ats.Dataset

  @moduledoc """
  Categorize offers per continent.

  It expects the path of two CSV files. The first one is the jobs dataset
  and the second one is the professions dataset.

      mix ats.categorize JOBS_PATH PROFESSIONS_PATH [--continents-quality [low,medium,high]]

  Default values:
  - JOBS_PATH: `priv/data/technical-test-jobs.csv`
  - PROFESSIONS_PATH: `priv/data/technical-test-professions.csv`
  - continents-quality: `low`

  The output is a table where the column is the job category and the row
  is the continent.

  Jobs dataset must be a CSV file with the following headers:

      profession_id,contract_type,name,office_latitude,office_longitude

  Professions dataset must be a CSV file with the following headers:

      id,name,category_name

  Continents dataset must be a GeoJSON file with the following format:

      {
        "features": [
          {
            "geometry": {"type": "MultiPolygon", "coordinates": []},
            "properties": {"continent": "Europe"}
          }
        ]
      }

  ## Examples

      mix ats.categorize technical-test-jobs.csv technical-test-professions.csv

  Would generate the following table:

      +---------------+-------+------+-------------------+---------+------+-------+--------+----------+
      |               | Total | Tech | Marketing / Comm' | Conseil | Créa | Admin | Retail | Business |
      +---------------+-------+------+-------------------+---------+------+-------+--------+----------+
      | Total         | 4943  | 1427 | 774               | 175     | 212  | 405   | 524    | 1426     |
      | Africa        | 9     | 3    | 1                 | 0       | 0    | 1     | 1      | 3        |
      | Asia          | 49    | 11   | 2                 | 0       | 0    | 1     | 7      | 28       |
      | Europe        | 4724  | 1400 | 759               | 175     | 205  | 394   | 424    | 1367     |
      | North America | 147   | 12   | 11                | 0       | 7    | 9     | 84     | 24       |
      | Oceania       | 9     | 0    | 1                 | 0       | 0    | 0     | 8      | 0        |
      | South America | 5     | 1    | 0                 | 0       | 0    | 0     | 0      | 4        |
      +---------------+-------+------+-------------------+---------+------+-------+--------+----------+
  """

  @shortdoc "Categorize offers per continent"
  @impl Mix.Task
  @spec run([binary]) :: :ok
  def run(args) do
    {jobs_path, professions_path, continent_quality} = parse_opts(args)

    {:ok, continents} =
      Dataset.continent_path!(continent_quality)
      |> Dataset.read_continents()

    categories =
      professions_path
      |> Dataset.read_professions!([:id, :category_name])
      |> Enum.reduce(%{}, fn %{id: id, category_name: category}, acc ->
        Map.put(acc, id, category)
      end)

    category_names =
      categories
      |> Enum.map(&elem(&1, 1))
      |> Enum.uniq()

    jobs_path
    |> Dataset.read_jobs!([:profession_id, :office_latitude, :office_longitude])
    |> Dataset.categories_per_continent(continents, categories)
    |> display_result(category_names)
  end

  defp parse_opts(args) do
    {opts, args, _} = OptionParser.parse(args, strict: [continents_quality: :string])

    quality =
      case Keyword.fetch(opts, :continents_quality) do
        {:ok, quality} ->
          if Enum.any?(["high", "medium", "low"], &(&1 == quality)) do
            String.to_atom(quality)
          else
            raise_with_help!(
              "Invalid --continents-quality argument, expects one of: low, medium or high"
            )
          end

        _ ->
          :low
      end

    if quality == :high do
      IO.puts(
        "Warning: with high quality, data calculation can take a really long time before showing any data."
      )
    end

    jobs = Enum.at(args, 0, "priv/data/technical-test-jobs.csv")
    professions = Enum.at(args, 1, "priv/data/technical-test-professions.csv")

    {jobs, professions, quality}
  end

  @spec raise_with_help!(any()) :: no_return()
  defp raise_with_help!(msg) do
    Mix.raise("""
    #{msg}

    For more help:
        mix help ats.categorize

    ## Examples

        mix ats.categorize technical-test-jobs.csv technical-test-professions.csv
    """)
  end

  # Display table result.
  defp display_result(result, category_names) do
    header = ["", "Total" | category_names]

    total_row = total_row(result, category_names)

    TableRex.quick_render!(
      [total_row | Enum.map(result, &compute_total_per_continent(&1, category_names))],
      header
    )
    |> IO.puts()
  end

  # First row of the table.
  defp total_row(result, category_names) do
    total = compute_total(result)
    total_per_category = compute_total_per_category(result, category_names)

    ["Total", total | total_per_category]
  end

  defp compute_total(result) do
    Enum.reduce(result, 0, fn {_, cont}, acc ->
      acc + Enum.reduce(cont, 0, fn {_, v}, acc -> acc + v end)
    end)
  end

  defp compute_total_per_category(result, category_names) do
    Enum.map(category_names, fn cat ->
      Enum.reduce(result, 0, fn {_, cont}, acc ->
        Map.get(cont, cat, 0) + acc
      end)
    end)
  end

  defp compute_total_per_continent({continent, categories}, category_names) do
    total = Enum.reduce(categories, 0, fn {_, v}, acc -> v + acc end)

    category_results =
      Enum.map(category_names, fn name ->
        Map.get(categories, name, 0)
      end)

    [continent, total | category_results]
  end
end
