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
      assert {:ok, %Profession{} = profession} = Applicants.update_profession(profession, @update_attrs)
      assert profession.category_name == "some updated category_name"
      assert profession.name == "some updated name"
    end

    test "update_profession/2 with invalid data returns error changeset" do
      profession = profession_fixture()
      assert {:error, %Ecto.Changeset{}} = Applicants.update_profession(profession, @invalid_attrs)
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
end
