defmodule Ats.DocWriter do
  alias Bureaucrat.JSON

  def write(records, path) do
    {:ok, file} = File.open(path, [:write, :utf8])
    records = group_records(records)
    write_intro(path, file)

    Enum.each(records, fn {controller, records} ->
      write_controller(controller, records, file)
    end)
  end

  defp write_intro(path, file) do
    intro_file_path =
      [
        # /path/to/API.md -> /path/to/API_INTRO.md
        String.replace(path, ~r/\.md$/i, "_INTRO\\0"),
        # /path/to/api.md -> /path/to/api_intro.md
        String.replace(path, ~r/\.md$/i, "_intro\\0"),
        # /path/to/API -> /path/to/API_INTRO
        "#{path}_INTRO",
        # /path/to/api -> /path/to/api_intro
        "#{path}_intro"
      ]
      # which one exists?
      |> Enum.find(nil, &File.exists?/1)

    if intro_file_path do
      file
      |> puts(File.read!(intro_file_path))
      |> puts("\n\n## Endpoints\n\n")
    else
      puts(file, "# ATS Examples\n")
    end
  end

  defp write_controller(controller, records, file) do
    puts(file, "## #{controller}")

    Enum.each(records, fn {_, records} ->
      write_action(records, file)
    end)
  end

  defp write_action(records, file) do
    Enum.each(records, &write_example(&1, file))
  end

  defp write_example(record, file) do
    path =
      case record.query_string do
        "" -> record.request_path
        str -> "#{record.request_path}?#{str}"
      end

    file
    |> puts("### #{record.assigns.bureaucrat_desc}")
    |> puts("#### Request")
    |> puts("* __Method:__ #{record.method}")
    |> puts("* __Path:__ #{path}")

    unless record.req_headers == [] do
      file
      |> puts("* __Request headers:__")
      |> puts("")
      |> puts("```")

      Enum.each(record.req_headers, fn {header, value} ->
        puts(file, "#{header}: #{value}")
      end)

      file
      |> puts("```")
    end

    unless record.body_params["query"] == nil do
      file
      |> puts("* __Request query:__")
      |> puts("")
      |> puts("```")
      |> puts("#{record.body_params["query"]}")
      |> puts("```")
    end

    unless record.body_params["variables"] == nil do
      file
      |> puts("* __Request variables:__")
      |> puts("")
      |> puts("```json")
      |> puts("#{format_body_params(record.body_params["variables"])}")
      |> puts("```")
    end

    file
    |> puts("")
    |> puts("#### Response")
    |> puts("* __Status__: #{record.status}")

    unless record.resp_headers == [] do
      file
      |> puts("* __Response headers:__")
      |> puts("")
      |> puts("```")

      Enum.each(record.resp_headers, fn {header, value} ->
        puts(file, "#{header}: #{value}")
      end)

      file
      |> puts("```")
    end

    file
    |> puts("* __Response body:__")
    |> puts("")
    |> puts("```json")
    |> puts("#{format_resp_body(record.resp_body)}")
    |> puts("```")
    |> puts("")
  end

  def format_body_params(params) do
    {:ok, json} = JSON.encode(params, pretty: true)
    json
  end

  defp format_resp_body("") do
    ""
  end

  defp format_resp_body(string) do
    {:ok, struct} = JSON.decode(string)
    {:ok, json} = JSON.encode(struct, pretty: true)
    json
  end

  defp puts(file, string) do
    IO.puts(file, string)
    file
  end

  defp strip_ns(module) do
    case to_string(module) do
      "Elixir." <> rest -> rest
      other -> other
    end
  end

  defp group_records(records) do
    by_controller = Bureaucrat.Util.stable_group_by(records, &get_controller/1)

    Enum.map(by_controller, fn {c, recs} ->
      {c, Bureaucrat.Util.stable_group_by(recs, &get_action/1)}
    end)
  end

  defp get_controller({_, opts}),
    do: opts[:group_title] || String.replace_suffix(strip_ns(opts[:module]), "Test", "")

  defp get_controller(conn),
    do: conn.assigns.bureaucrat_opts[:group_title] || strip_ns(conn.private.phoenix_controller)

  defp get_action({_, opts}), do: opts[:description]
  defp get_action(conn), do: conn.private.phoenix_action
end
