defmodule Ats.WorldTest do
  use Ats.DataCase

  alias Ats.World

  describe "continents" do
    alias Ats.World.Continent

    @square %Geo.MultiPolygon{
      coordinates: [[[{0.0, 0.0}, {0.0, 100.0}, {100.0, 100.0}, {100.0, 0.0}, {0.0, 0.0}]]]
    }
    @neg_square %Geo.MultiPolygon{
      coordinates: [[[{0.0, 0.0}, {0.0, -100.0}, {-100.0, -100.0}, {-100.0, 0.0}, {0.0, 0.0}]]]
    }
    @invalid_shape %Geo.Point{coordinates: {0.0, 0.0}}
    @valid_attrs %{name: "some name", shape: @square}
    @update_attrs %{name: "some updated name", shape: @neg_square}
    @invalid_attrs %{name: nil, shape: nil}

    def continent_fixture(attrs \\ %{}) do
      {:ok, continent} =
        attrs
        |> Enum.into(@valid_attrs)
        |> World.create_continent()

      continent
    end

    test "list_continents/0 returns all continents" do
      continent = continent_fixture()
      assert World.list_continents() == [continent]
    end

    test "get_continent!/1 returns the continent with given id" do
      continent = continent_fixture()
      assert World.get_continent!(continent.id) == continent
    end

    test "create_continent/1 with valid data creates a continent" do
      assert {:ok, %Continent{} = continent} = World.create_continent(@valid_attrs)
      assert continent.name == "some name"
      assert continent.shape == @square
    end

    test "create_continent/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = World.create_continent(@invalid_attrs)
    end

    test "create_continent/1 with invalid shape returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               World.create_continent(%{@valid_attrs | shape: @invalid_shape})
    end

    test "update_continent/2 with valid data updates the continent" do
      continent = continent_fixture()
      assert {:ok, %Continent{} = continent} = World.update_continent(continent, @update_attrs)
      assert continent.name == "some updated name"
      assert continent.shape == @neg_square
    end

    test "update_continent/2 with invalid data returns error changeset" do
      continent = continent_fixture()
      assert {:error, %Ecto.Changeset{}} = World.update_continent(continent, @invalid_attrs)
      assert continent == World.get_continent!(continent.id)
    end

    test "delete_continent/1 deletes the continent" do
      continent = continent_fixture()
      assert {:ok, %Continent{}} = World.delete_continent(continent)
      assert_raise Ecto.NoResultsError, fn -> World.get_continent!(continent.id) end
    end

    test "change_continent/1 returns a continent changeset" do
      continent = continent_fixture()
      assert %Ecto.Changeset{} = World.change_continent(continent)
    end
  end
end
