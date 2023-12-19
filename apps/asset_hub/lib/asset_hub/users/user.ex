defmodule AssetHub.Users.User do
  use AssetHub.Schema
  import Ecto.Changeset

  schema "users_profiles" do
    field :given_name, :string
    field :family_name, :string

    has_many :assets, AssetHub.Assets.Asset, foreign_key: :owner_id
    has_one :account, {"users_to_users_profiles", AssetHub.Accounts.User}, foreign_key: :profile_id

    timestamps()
  end

  @doc """
  A user changeset for registration.
  """
  def registration_changeset(user, attrs) do
    user
    |> cast(attrs, [:given_name, :family_name])
    |> validate_required([:given_name, :family_name])
    |> validate_length(:given_name, min: 1, max: 100)
    |> validate_length(:family_name, min: 1, max: 100)
  end
end
