defmodule AssetHub.AssetsTest do
  use AssetHub.DataCase

  alias AssetHub.Assets
  alias AssetHub.Assets.Asset

  describe "get_asset!/1" do
    test "raises if id is invalid" do
      assert_raise Ecto.NoResultsError, fn ->
        Assets.get_asset!("11111111-1111-1111-1111-111111111111")
      end
    end

    test "returns the asset with the given id" do
      %{id: asset_id} = asset_fixture()
      assert %{id: ^asset_id} = Assets.get_asset!(asset_id)
    end
  end

  describe "register_asset/1" do
    test "requires asset_tag to be set" do
      {:error, changeset} = Assets.register_asset(%{})

      assert "can't be blank" in errors_on(changeset).asset_tag
    end

    test "validates asset_tag when given" do
      {:error, changeset} = Assets.register_asset(%{asset_tag: ""})
      assert "can't be blank" in errors_on(changeset).asset_tag
    end

    test "validates asset_tag uniqueness" do
      %{asset_tag: asset_tag} = asset_fixture(asset_tag: "10abc")
      {:error, changeset} = Assets.register_asset(%{asset_tag: asset_tag})
      assert "has already been taken" in errors_on(changeset).asset_tag

      {:error, changeset} = Assets.register_asset(%{asset_tag: String.upcase(asset_tag)})
      assert "has already been taken" in errors_on(changeset).asset_tag
    end

    test "registers asset" do
      asset_tag = unique_asset_tag()
      serial_number = "123ABC"
      {:ok, asset} = Assets.register_asset(%{asset_tag: asset_tag, serial_number: serial_number})
      assert asset.asset_tag == asset_tag
      assert asset.serial_number == serial_number
    end
  end

  describe "change_asset_registration/2" do
    test "returns a changeset" do
      assert %Ecto.Changeset{} = changeset = Assets.change_asset_registration(%Asset{})
      assert changeset.required == [:asset_tag]
    end

    test "allows fields to be set" do
      asset_tag = unique_asset_tag()
      serial_number = "123ABC"

      changeset =
        Assets.change_asset_registration(
          %Asset{},
          %{asset_tag: asset_tag, serial_number: serial_number}
        )

      assert changeset.valid?
      assert get_change(changeset, :asset_tag) == asset_tag
      assert get_change(changeset, :serial_number) == serial_number
    end
  end

  describe "assign_owner/2" do
    setup _ do
      %{asset: asset_fixture(), user: user_fixture()}
    end

    test "assigns asset to user", %{asset: asset, user: user} do
      refute asset.owner_id == user.id
      {:ok, asset} = Assets.assign_owner(asset, user.id)
      assert asset.owner_id == user.id
    end

    test "can unassign owner", %{asset: asset, user: user} do
      {:ok, asset} = Assets.assign_owner(asset, user.id)
      assert asset.owner_id == user.id

      {:ok, asset} = Assets.assign_owner(asset, nil)
      assert asset.owner_id == nil
    end

    test "raises if user does not exist", %{asset: asset} do
      user_id = "11111111-1111-1111-1111-111111111111"

      assert_raise Ecto.NoResultsError, fn ->
        Assets.assign_owner(asset, user_id)
      end
    end
  end

  defp unique_asset_tag, do: System.unique_integer() |> to_string()

  defp asset_fixture(attrs \\ %{}) do
    {:ok, asset} =
      attrs
      |> Enum.into(%{asset_tag: unique_asset_tag()})
      |> Assets.register_asset()

    asset
  end

  defp user_fixture do
    {:ok, user} =
      %{given_name: "Test", family_name: "User"}
      |> AssetHub.Users.register_user()

    user
  end
end
