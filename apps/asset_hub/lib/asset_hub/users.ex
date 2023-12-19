defmodule AssetHub.Users do
  @moduledoc """
  Provides an API for interacting with Users.
  """

  alias AssetHub.Repo
  import Ecto.Query, warn: false

  alias AssetHub.Users.User

  ## Getters

  @doc """
  Gets a single user.

  Returns `Ecto.NoResultsError` if no user is found.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)
  """
  def get_user!(id), do: Repo.get!(User, id)

  ## Registration

  @doc """
  Registers a user.

  ## Examples

      iex> register_user(%{field: value})
      {:ok, %User{}}

      iex> register_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def register_user(attrs) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns an asset changeset for tracking registration changes.
  """
  def change_user_registration(user, attrs) do
    User.registration_changeset(user, attrs)
  end
end
