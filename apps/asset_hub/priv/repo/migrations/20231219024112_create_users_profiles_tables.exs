defmodule AssetHub.Repo.Migrations.CreateUsersProfilesTables do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:users_profiles, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :given_name, :citext
      add :family_name, :citext
      timestamps()
    end

    ## Join Accounts.User to Users.User

    create table(:accounts_profiles, primary_key: false) do
      add :account_id, references(:users, type: :binary_id), primary_key: true
      add :profile_id, references(:users_profiles, type: :binary_id), primary_key: true
    end

    ## Add owner field to assets

    alter table(:assets) do
      add :owner_id, references(:users_profiles, type: :binary_id)
    end
  end
end
