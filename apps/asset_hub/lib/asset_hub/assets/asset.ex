defmodule AssetHub.Assets.Asset do
  use AssetHub.Schema
  import Ecto.Changeset

  schema "assets" do
    field :asset_tag, :string
    field :serial_number, :string

    belongs_to :owner, AssetHub.Users.User
    timestamps()
  end

  @doc """
  An asset changeset for registration.

  ## Options

    * `:validate_asset_tag` - Validates the uniqueness of the asset tag, in
      case you don't want to validate the uniqueness of the asset tag (like
      when using this changeset for validations on a LiveView form before
      submitting the form), this option can be set to `false`.
      Defaults to `true`.
  """
  def registration_changeset(asset, attrs, opts \\ []) do
    asset
    |> cast(attrs, [:asset_tag, :serial_number])
    |> validate_asset_tag(opts)
  end

  defp validate_asset_tag(changeset, opts) do
    changeset
    |> validate_required([:asset_tag])
    |> validate_length(:asset_tag, min: 1)
    |> maybe_validate_unique_asset_tag(opts)
  end

  defp maybe_validate_unique_asset_tag(changeset, opts) do
    if Keyword.get(opts, :validate_asset_tag, true) do
      changeset
      |> unsafe_validate_unique(:asset_tag, AssetHub.Repo)
      |> unique_constraint(:asset_tag)
    else
      changeset
    end
  end

  @doc """
  An asset changeset for changing the owner.

  It requires the provided user to exist (if not nil), otherwise an error is added.
  """
  def owner_changeset(asset, attrs) do
    asset
    |> cast(attrs, [:owner_id])
    |> foreign_key_constraint(:owner_id)
  end
end
