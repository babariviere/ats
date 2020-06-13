Bureaucrat.start(
  json_library: Phoenix.json_library(),
  writer: Ats.DocWriter,
  default_path: "guides/examples.md"
)

ExUnit.start(formatters: [ExUnit.CLIFormatter, Bureaucrat.Formatter])
Ecto.Adapters.SQL.Sandbox.mode(Ats.Repo, :manual)
