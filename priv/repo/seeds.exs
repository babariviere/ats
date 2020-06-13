# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Ats.Repo.insert!(%Ats.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

Ats.Dataset.continent_path!(:high)
|> Ats.Dataset.read_continents!()
|> Enum.map(&Ats.World.change_continent/1)
|> Enum.map(&Ats.Repo.insert!/1)
