defmodule AssetHub.UsersTest do
  use AssetHub.DataCase

  alias AssetHub.Users
  alias AssetHub.Users.User

  describe "get_user/1" do
    test "raises if id is invalid" do
      assert_raise Ecto.NoResultsError, fn ->
        Users.get_user!("11111111-1111-1111-1111-111111111111")
      end
    end

    test "returns the user with the given id" do
      %{id: user_id} = user_fixture()
      assert %{id: ^user_id} = Users.get_user!(user_id)
    end
  end

  describe "register_user/1" do
    test "requires given_name and family_name to be set" do
      {:error, changeset} = Users.register_user(%{})
      assert "can't be blank" in errors_on(changeset).given_name
      assert "can't be blank" in errors_on(changeset).family_name
    end

    test "validates given_name and family_name when given" do
      {:error, changeset} = Users.register_user(%{given_name: "", family_name: ""})
      assert "can't be blank" in errors_on(changeset).given_name
      assert "can't be blank" in errors_on(changeset).family_name
    end

    test "validates maximum values for given_name and family_name" do
      too_long = String.duplicate("db", 100)
      {:error, changeset} = Users.register_user(%{given_name: too_long, family_name: too_long})
      assert "should be at most 100 character(s)" in errors_on(changeset).given_name
      assert "should be at most 100 character(s)" in errors_on(changeset).family_name
    end

    test "registers user" do
      given = "Test"
      family = "User"

      {:ok, user} = Users.register_user(%{given_name: given, family_name: family})
      assert user.given_name == given
      assert user.family_name == family
    end
  end

  describe "change_user_registration/2" do
    test "returns a changeset" do
      %Ecto.Changeset{} = changeset = Users.change_user_registration(%User{})
      assert changeset.required == [:given_name, :family_name]
    end

    test "allows fields to be set" do
      attrs = %{given_name: "Test", family_name: "User"}
      changeset = Users.change_user_registration(%User{}, attrs)

      assert changeset.valid?
      assert get_change(changeset, :given_name) == attrs.given_name
      assert get_change(changeset, :family_name) == attrs.family_name
    end
  end

  defp user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{given_name: "Test", family_name: "#{System.unique_integer()}"})
      |> Users.register_user()

    user
  end
end
