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
|> Enum.map(&Ats.Repo.insert!(&1, on_conflict: :replace_all, conflict_target: :name))

"priv/data/technical-test-professions.csv"
|> Ats.Dataset.read_professions!()
|> Enum.map(&struct(Ats.Applicants.Profession, &1))
|> Enum.map(&Ats.Repo.insert!(&1, on_conflict: :replace_all, conflict_target: :id))

"priv/data/technical-test-jobs.csv"
|> Ats.Dataset.read_jobs!()
|> Enum.map(fn x ->
  job = struct(Ats.Applicants.Job, x)

  place = %Geo.Point{
    coordinates: {x.office_longitude, x.office_latitude}
  }

  %{job | place: place}
end)
|> Enum.map(&Ats.Applicants.Job.profession_changeset(&1, %{}))
|> Enum.map(&Ats.Repo.insert!/1)
