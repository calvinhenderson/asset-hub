defmodule AssetHub.Repo.Migrations.CreateAssetsTables do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:assets, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :asset_tag, :citext, null: false
      add :serial_number, :citext
      timestamps()
    end

    create unique_index(:assets, [:asset_tag])
    create index(:assets, [:serial_number])
  end
end
