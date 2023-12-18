defmodule AssetHub.Schema do
  @moduledoc """
  Helper module for defining an `Ecto.Schema`.

  Sets the primary key field to `id`.
  Sets the primary and foreign key types to `:binary_id` (UUID)
  """
  defmacro __using__(_) do
    quote do
      use Ecto.Schema

      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id
    end
  end
end
