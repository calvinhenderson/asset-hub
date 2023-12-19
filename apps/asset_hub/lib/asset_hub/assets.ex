defmodule AssetHub.Assets do
  @moduledoc """
  Provides an API for interacting with Assets.
  """

  alias AssetHub.Repo
  import Ecto.Query, warn: false

  alias AssetHub.Assets.Asset

  ## Getters

  @doc """
  Gets a single asset.

  Returns `Ecto.NoResultsError` if no asset is found.

  ## Examples

      iex> get_asset!(123)
      %Asset{}

      iex> get_asset!(456)
      ** (Ecto.NoResultsError)
  """
  def get_asset!(id), do: Repo.get!(Asset, id)

  ## Registration

  @doc """
  Registers an asset.

  ## Examples

      iex> register_asset(%{field: value})
      {:ok, %Asset{}}

      iex> register_asset(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def register_asset(attrs) do
    %Asset{}
    |> Asset.registration_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns an asset changeset for tracking registration changes.
  """
  def change_asset_registration(asset, attrs \\ %{}) do
    Asset.registration_changeset(asset, attrs)
  end

  ## Owner Assignment

  @doc """
  Assigns an asset to a user.

  ## Examples

      iex> assign_owner(asset, user_id)
      {:ok, %Asset{}}

      iex> assign_owner(asset, nil)
      {:ok, %Asset{}}

      iex> assign_owner(asset, bad_user_id)
      ** (Ecto.NoResultsError)
  """
  def assign_owner(asset, user_id) do
    owner_id =
      if user_id do
        %{id: id} = AssetHub.Users.get_user!(user_id)
        id
      else
        nil
      end

    asset
    |> Asset.owner_changeset(%{owner_id: owner_id})
    |> Repo.update()
  end
end
