defmodule AssetHub.Repo do
  use Ecto.Repo,
    otp_app: :asset_hub,
    adapter: Ecto.Adapters.Postgres
end
