defmodule Ats.Dataset do
  @moduledoc """
  Provides functions to manipulate datasets.
  """

  alias NimbleCSV.RFC4180, as: CSV

  @continents_resolutions [:low, :medium, :high]
  @doc """
  Returns continents GeoJSON file per it's resolution.

  Raises an exception if resolution is an invalid argument.

  ## Examples

      iex> Ats.Dataset.continent_path!()
      "priv/data/continents/medium.geojson"

  Or by specifying resolution:

      iex> Ats.Dataset.continent_path!(:low)
      "priv/data/continents/low.geojson"

  Giving an invalid atom will raise an error:

      iex> Ats.Dataset.continent_path!(:test)
      ** (ArgumentError) invalid resolution, expected one of [:low, :medium, :high], got :test
  """
  @spec continent_path!(:low | :medium | :high) :: String.t() | no_return()
  def continent_path!(resolution \\ :medium) do
    case resolution do
      resolution when resolution in @continents_resolutions ->
        "priv/data/continents/#{resolution}.geojson"

      _ ->
        raise ArgumentError,
              "invalid resolution, expected one of #{inspect(@continents_resolutions)}, got :#{
                resolution
              }"
    end
  end

  @doc """
  Read continent file in GeoJSON format.

  GeoJSON file must be in the format:

      {
        "features": [
          {
            "geometry": {"type": "MultiPolygon", "coordinates": []},
            "properties": {"continent": "Europe"}
          }
        ]
      }

  ## Examples

      iex> Ats.Dataset.read_continents("test/data/valid/continents.geojson")
      {:ok, [%Ats.World.Continent{
          name: "Europe",
          shape: %Geo.MultiPolygon{coordinates: [], properties: %{}, srid: nil}
        }]}

  You can get an error if path does not exists or file is not properly formatted.

      iex> Ats.Dataset.read_continents("invalid path")
      {:error, :enoent}

  If the file is not properly formatted:

      iex> Ats.Dataset.read_continents("test/data/invalid/continent_format.geojson")
      {:error, :invalid_format}
  """
  @spec read_continents(binary) ::
          {:ok, list(Ats.World.Continent.t())}
          | {:error, File.posix()}
          | {:error, :invalid_format}
  def read_continents(path) do
    with {:ok, content} <- File.read(path),
         {:ok, json} when is_map(json) <- Jason.decode(content),
         {:ok, features} <- Map.fetch(json, "features") do
      Enum.reduce_while(features, {:ok, []}, fn feature, {:ok, acc} ->
        case parse_continent_feature(feature) do
          {:ok, elem} -> {:cont, {:ok, [elem | acc]}}
          :error -> {:halt, {:error, :invalid_format}}
        end
      end)
    else
      {:error, atom} when is_atom(atom) -> {:error, atom}
      {:error, %Jason.DecodeError{}} -> {:error, :invalid_format}
      _ -> {:error, :invalid_format}
    end
  end

  defp parse_continent_feature(feature) do
    with {:ok, geometry} <- Map.fetch(feature, "geometry"),
         {:ok, shape} <- Geo.JSON.decode(geometry),
         {:ok, properties} <- Map.fetch(feature, "properties"),
         {:ok, continent} <- Map.fetch(properties, "continent") do
      {:ok, %Ats.World.Continent{name: continent, shape: shape}}
    else
      _ -> :error
    end
  end

  # Keys for profession dataset
  @profession_keys [:id, :name, :category_name]
  @doc """
  Read professions file in CSV format.

  Expected headers is:

      id,name,category_name

  If `id` is omitted, the data will be skipped.

  The file must be [RFC4180](https://tools.ietf.org/html/rfc4180#section-2).
  This means the format must have:
  - separator: `,`
  - escape: `""`

  ## Examples

      iex> Ats.Dataset.read_professions!("test/data/valid/professions.csv")
      [%{id: 1, name: "Developer", category_name: "Tech"}]

  You can also filters keys to avoid returning a big map.

      iex> Ats.Dataset.read_professions!("test/data/valid/professions.csv", [:id, :category_name])
      [%{id: 1, category_name: "Tech"}]

  You can get an error if path does not exists or file is not properly formatted.

      iex> Ats.Dataset.read_professions!("invalid path")
      ** (File.Error) could not stream "invalid path": no such file or directory

  If the file have an invalid header:

      iex> Ats.Dataset.read_professions!("test/data/invalid/professions_header.csv")
      ** (RuntimeError) "test/data/invalid/professions_header.csv" has an invalid csv header, expected: [:id, :name, :category_name]
  """
  @spec read_professions!(
          String.t(),
          list(atom())
        ) :: list(map()) | no_return()
  def read_professions!(path, keys \\ @profession_keys) do
    keys = intersection(keys, @profession_keys)

    stream =
      path
      |> File.stream!(read_ahead: 100_000)
      |> CSV.parse_stream(skip_headers: false)

    case parse_csv_headers(hd(Enum.take(stream, 1)), @profession_keys) do
      {:ok, headers} ->
        map_row = &map_profession_row(&1, headers, keys)

        stream
        |> Stream.drop(1)
        |> Stream.flat_map(map_row)
        |> Enum.to_list()

      _ ->
        raise "\"#{path}\" has an invalid csv header, expected: #{inspect(@profession_keys)}"
    end
  end

  # Map a CSV row into a profession map.
  #
  # Returns a list for flat_map. Either it has one or 0 element.
  defp map_profession_row(values, headers, keys) do
    map =
      Enum.zip(headers, values)
      |> Enum.into(Map.new())

    case Integer.parse(map.id) do
      {id, _} ->
        map =
          map
          |> Map.put(:id, id)
          |> Map.take(keys)

        [map]

      _ ->
        []
    end
  end

  @job_keys [:profession_id, :contract_type, :name, :office_latitude, :office_longitude]
  @doc """
  Read jobs file in CSV format.

  Expected headers is:

      profession_id,contract_type,name,office_latitude,office_longitude

  If any of `profession_id`, `office_latitude` or `office_longitude` is invalid, the data will be skipped.

  The file must be [RFC4180](https://tools.ietf.org/html/rfc4180#section-2).
  This means the format must have:
  - separator: `,`
  - escape: `""`

  ## Examples

      iex> Ats.Dataset.read_jobs!("test/data/valid/jobs.csv")
      [%{profession_id: 1, contract_type: "FULL_TIME", name: "Backend Dev", office_latitude: 0.0, office_longitude: 0.0}]

  You can also filters keys to avoid returning a big map.

      iex> Ats.Dataset.read_jobs!("test/data/valid/jobs.csv", [:profession_id, :name])
      [%{profession_id: 1, name: "Backend Dev"}]

  You can get an error if path does not exists or file is not properly formatted.

      iex> Ats.Dataset.read_jobs!("invalid path")
      ** (File.Error) could not stream "invalid path": no such file or directory

  If the file have an invalid header:

      iex> Ats.Dataset.read_jobs!("test/data/invalid/jobs_header.csv")
      ** (RuntimeError) "test/data/invalid/jobs_header.csv" has an invalid csv header, expected: [:id, :name, :category_name]
  """
  def read_jobs!(path, keys \\ @job_keys) do
    keys = intersection(keys, @job_keys)

    stream =
      path
      |> File.stream!(read_ahead: 100_000)
      |> CSV.parse_stream(skip_headers: false)

    case parse_csv_headers(hd(Enum.take(stream, 1)), @job_keys) do
      {:ok, headers} ->
        map_row = &map_job_row(&1, headers, keys)

        stream
        |> Stream.drop(1)
        |> Stream.flat_map(map_row)
        |> Enum.to_list()

      _ ->
        raise "\"#{path}\" has an invalid csv header, expected: #{inspect(@profession_keys)}"
    end
  end

  # Map a CSV row into a job map.
  #
  # Returns a list for flat_map. Either it has one or 0 element.
  defp map_job_row(values, headers, keys) do
    map =
      Enum.zip(headers, values)
      |> Enum.into(Map.new())

    with {profession_id, _} <- Integer.parse(map.profession_id),
         {office_latitude, _} <- Float.parse(map.office_latitude),
         {office_longitude, _} <- Float.parse(map.office_longitude) do
      map =
        map
        |> Map.put(:profession_id, profession_id)
        |> Map.put(:office_latitude, office_latitude)
        |> Map.put(:office_longitude, office_longitude)
        |> Map.take(keys)

      [map]
    else
      _ -> []
    end
  end

  @doc """
  Count the number of categories per continents.

  Returns a map of category where the key is the continent name. Example:

      %{
        "Europe" => %{
          "Tech" => 10
        }
      }

  The first argument is the jobs list. Required keys are :profession_id, :office_latitude and :office_longitude.
  It is used to get professions (which contains category name) per office location.
  The second and third arguments are the continents and categories list.
  """
  @type category() :: %{id: integer(), category_name: String.t()}
  @type job() :: %{profession_id: integer(), office_latitude: float(), office_longitude: float()}
  @spec categories_per_continent(list(job()), list(Ats.World.Continent.t()), list(category())) ::
          list(map())
  def categories_per_continent(jobs, continents, categories) do
    native_continents =
      continents
      |> Enum.map(&{&1.name, Ats.Native.continent_new(&1.shape.coordinates)})

    jobs
    |> Flow.from_enumerable()
    |> Flow.partition(stages: 8)
    |> Flow.flat_map(fn job ->
      category = categories[job.profession_id]

      point = %Geo.Point{
        coordinates: {job.office_longitude, job.office_latitude}
      }

      continent =
        Enum.find(native_continents, fn {_, continent} ->
          Ats.Native.shape_contains?(continent, point.coordinates)
        end)

      if continent != nil, do: [{elem(continent, 0), category}], else: []
    end)
    # Partition per continent, as we are using continent as a key
    |> Flow.partition(key: {:elem, 0}, stages: length(continents))
    |> Flow.reduce(fn -> %{} end, fn {continent, category}, acc ->
      update_in(acc, [Access.key(continent, %{}), Access.key(category, 0)], &(&1 + 1))
    end)
    |> Enum.sort_by(&elem(&1, 0), :asc)
  end

  @doc """
  Parse a CSV header and map it to list of atoms.

  The order of the list will be determined by csv_header.

  ## Example

      iex> Ats.Dataset.parse_csv_headers(["id", "profession"], [:profession, :id])
      {:ok, [:id, :profession]}

  If you want to reverse order, modify csv_header like this:

      iex> Ats.Dataset.parse_csv_headers(["profession", "id"], [:profession, :id])
      {:ok, [:profession, :id]}

  If the length doesn't match, it returns an error:

      iex> Ats.Dataset.parse_csv_headers(["id", "profession"], [:profession])
      :error

  If a key doesn't exists in the expected list:

      iex> Ats.Dataset.parse_csv_headers(["id", "hello"], [:id, :profession])
      :error
  """
  @spec parse_csv_headers(list(String.t()), list(atom())) :: {:ok, list(atom())} | :error
  def parse_csv_headers(csv_header, expect) when length(csv_header) == length(expect) do
    expect_map =
      expect
      |> Enum.map(fn x -> {to_string(x), x} end)
      |> Enum.into(Map.new())

    csv_header
    |> Enum.reverse()
    |> Enum.reduce_while({:ok, []}, fn header, {:ok, acc} ->
      case Map.fetch(expect_map, header) do
        {:ok, atom} -> {:cont, {:ok, [atom | acc]}}
        :error -> {:halt, :error}
      end
    end)
  end

  def parse_csv_headers(_, _), do: :error

  # Returns a list containing only members that list1 and list2 have in common.
  defp intersection(list1, list2) do
    Enum.filter(list1, fn elem1 ->
      Enum.any?(list2, fn elem2 -> elem1 == elem2 end)
    end)
  end
end
