defmodule AtsWeb.Schema.Pagination do
  @moduledoc """
  Provide pagination arguments for any GraphQL field.
  """

  import Ecto.Query, only: [from: 2]

  @max_result 100

  @doc """
  Generate pagination arguments for a GraphQL field.
  """
  defmacro pagination do
    quote do
      arg(:first, :integer)
      arg(:offset, :integer)
    end
  end

  @doc """
  Apply pagination to a query.

  ## Example

      query = from p in Post
      Pagination.apply(Post, args) # where args is resolver args
      |> Repo.all()
  """
  def apply(query, args) do
    limit = min(args[:first] || @max_result, @max_result)
    offset = args[:offset]

    from q in query,
      limit: ^limit,
      offset: ^offset
  end
end
