defmodule Conduit.AccountsTest do
  use Conduit.DataCase

  alias Conduit.Accounts

  describe "register user" do
    alias Conduit.Accounts.Projections.User

    @tag :integration
    test "should succeed with valid data" do
      assert {:ok, %User{} = user} = Accounts.register_user(build(:user))

      assert user.username == "jake"
      assert user.email == "jake@jake.jake"
      assert user.hashed_password == "jakejake"
      assert user.bio == nil
      assert user.image == nil
    end

    @tag :integration
    test "should fail with invalid data and return error" do
      assert {:error, :validation_failure, errors} = Accounts.register_user(build(:user, username: ""))

      assert errors == %{username: ["must be present"]}
    end
  end
end
