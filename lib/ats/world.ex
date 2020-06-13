defmodule Ats.World do
  @moduledoc """
  The World context.
  """

  import Ecto.Query, warn: false
  alias Ats.Repo

  alias Ats.World.Continent

  @doc """
  Returns the list of continents.

  ## Examples

      iex> list_continents()
      [%Continent{}, ...]

  """
  def list_continents do
    Repo.all(Continent)
  end

  @doc """
  Gets a single continent.

  Raises `Ecto.NoResultsError` if the Continent does not exist.

  ## Examples

      iex> get_continent!(123)
      %Continent{}

      iex> get_continent!(456)
      ** (Ecto.NoResultsError)

  """
  def get_continent!(id), do: Repo.get!(Continent, id)

  @doc """
  Creates a continent.

  ## Examples

      iex> create_continent(%{field: value})
      {:ok, %Continent{}}

      iex> create_continent(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_continent(attrs \\ %{}) do
    %Continent{}
    |> Continent.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a continent.

  ## Examples

      iex> update_continent(continent, %{field: new_value})
      {:ok, %Continent{}}

      iex> update_continent(continent, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_continent(%Continent{} = continent, attrs) do
    continent
    |> Continent.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a continent.

  ## Examples

      iex> delete_continent(continent)
      {:ok, %Continent{}}

      iex> delete_continent(continent)
      {:error, %Ecto.Changeset{}}

  """
  def delete_continent(%Continent{} = continent) do
    Repo.delete(continent)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking continent changes.

  ## Examples

      iex> change_continent(continent)
      %Ecto.Changeset{data: %Continent{}}

  """
  def change_continent(%Continent{} = continent, attrs \\ %{}) do
    Continent.changeset(continent, attrs)
  end
end
