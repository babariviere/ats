defmodule AtsWeb.ProfessionsResolver do
  @moduledoc """
  Resolver for professions method.
  """

  @doc """
  Returns a list of all professions.
  """
  def all_professions(_root, _args, _info) do
    {:ok, Ats.Applicants.list_professions()}
  end
end
