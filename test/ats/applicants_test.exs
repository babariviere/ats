defmodule Ats.ApplicantsTest do
  use Ats.DataCase

  alias Ats.Applicants

  describe "professions" do
    alias Ats.Applicants.Profession

    @valid_attrs %{category_name: "some category_name", name: "some name"}
    @update_attrs %{category_name: "some updated category_name", name: "some updated name"}
    @invalid_attrs %{category_name: nil, name: nil}

    def profession_fixture(attrs \\ %{}) do
      {:ok, profession} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Applicants.create_profession()

      profession
    end

    test "list_professions/0 returns all professions" do
      profession = profession_fixture()
      assert Applicants.list_professions() == [profession]
    end

    test "get_profession!/1 returns the profession with given id" do
      profession = profession_fixture()
      assert Applicants.get_profession!(profession.id) == profession
    end

    test "create_profession/1 with valid data creates a profession" do
      assert {:ok, %Profession{} = profession} = Applicants.create_profession(@valid_attrs)
      assert profession.category_name == "some category_name"
      assert profession.name == "some name"
    end

    test "create_profession/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Applicants.create_profession(@invalid_attrs)
    end

    test "update_profession/2 with valid data updates the profession" do
      profession = profession_fixture()

      assert {:ok, %Profession{} = profession} =
               Applicants.update_profession(profession, @update_attrs)

      assert profession.category_name == "some updated category_name"
      assert profession.name == "some updated name"
    end

    test "update_profession/2 with invalid data returns error changeset" do
      profession = profession_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Applicants.update_profession(profession, @invalid_attrs)

      assert profession == Applicants.get_profession!(profession.id)
    end

    test "delete_profession/1 deletes the profession" do
      profession = profession_fixture()
      assert {:ok, %Profession{}} = Applicants.delete_profession(profession)
      assert_raise Ecto.NoResultsError, fn -> Applicants.get_profession!(profession.id) end
    end

    test "change_profession/1 returns a profession changeset" do
      profession = profession_fixture()
      assert %Ecto.Changeset{} = Applicants.change_profession(profession)
    end
  end

  describe "jobs" do
    alias Ats.Applicants.Job

    @valid_point %Geo.Point{coordinates: {1.0, 2.0}}
    @updated_point %Geo.Point{coordinates: {2.0, 3.0}}

    @valid_attrs %{contract_type: :full_time, name: "some name", place: @valid_point}
    @update_attrs %{
      contract_type: :part_time,
      name: "some updated name",
      place: @updated_point
    }
    @invalid_attrs %{contract_type: nil, name: nil, place: nil}

    def job_fixture(attrs \\ %{}) do
      {:ok, job} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Applicants.create_job()

      job
    end

    test "list_jobs/0 returns all jobs" do
      job = job_fixture()
      assert Applicants.list_jobs() == [job]
    end

    test "get_job!/1 returns the job with given id" do
      job = job_fixture()
      assert Applicants.get_job!(job.id) == job
    end

    test "create_job/1 with valid data creates a job" do
      assert {:ok, %Job{} = job} = Applicants.create_job(@valid_attrs)
      assert job.contract_type == :full_time
      assert job.name == "some name"
      assert job.place == @valid_point
    end

    test "create_job/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Applicants.create_job(@invalid_attrs)
    end

    test "update_job/2 with valid data updates the job" do
      job = job_fixture()
      assert {:ok, %Job{} = job} = Applicants.update_job(job, @update_attrs)
      assert job.contract_type == :part_time
      assert job.name == "some updated name"
      assert job.place == @updated_point
    end

    test "update_job/2 with invalid data returns error changeset" do
      job = job_fixture()
      assert {:error, %Ecto.Changeset{}} = Applicants.update_job(job, @invalid_attrs)
      assert job == Applicants.get_job!(job.id)
    end

    test "delete_job/1 deletes the job" do
      job = job_fixture()
      assert {:ok, %Job{}} = Applicants.delete_job(job)
      assert_raise Ecto.NoResultsError, fn -> Applicants.get_job!(job.id) end
    end

    test "change_job/1 returns a job changeset" do
      job = job_fixture()
      assert %Ecto.Changeset{} = Applicants.change_job(job)
    end

    test "Job.profession_changeset/2 takes a profession" do
      attrs = Map.put(@valid_attrs, :profession, %{name: "Tester", category_name: "Tech"})

      assert {:ok, %Job{} = job} =
               %Job{}
               |> Applicants.Job.profession_changeset(attrs)
               |> Ats.Repo.insert()

      assert job == Applicants.get_job!(job.id) |> Repo.preload(:profession)
    end
  end
end
