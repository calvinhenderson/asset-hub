defmodule AssetHub.Users.User do
  use AssetHub.Schema
  import Ecto.Changeset

  schema "users_profiles" do
    field :given_name, :string
    field :family_name, :string

    has_many :assets, AssetHub.Assets.Asset
    has_one :account, {"users_to_users_profiles", AssetHub.Accounts.User}, foreign_key: :profile_id

    timestamps()
  end

  @doc """
  A user changeset for registration.
  """
  def registration_changeset(user, attrs) do
    user
    |> cast(attrs, [:given_name, :family_name])
  end
end
