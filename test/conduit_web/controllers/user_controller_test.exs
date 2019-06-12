defmodule ConduitWeb.UserControllerTest do
  use ConduitWeb.ConnCase

  alias ConduitWeb.Router.Helpers, as: Routes
  alias Conduit.Accounts.Projections.User
  alias Conduit.Repo

  import Conduit.Factory

  def user_fixture(:user, attrs \\ []) do
    fields = [:uuid, :email, :username, :hashed_password, :bio, :image]
    attrs = build(:user, attrs) |> Map.put(:uuid, UUID.uuid4())
    user = Ecto.Changeset.cast(%User{}, attrs, fields) |> Repo.insert!()

    {:ok, user}
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "register user" do
    @tag :web
    test "should create and return user when data is valid", %{conn: conn} do
      conn = post conn, Routes.user_path(conn, :create), user: build(:user)
      json = json_response(conn, 201)["data"]

      assert {:ok, _} = UUID.info(json["uuid"])
      assert json["email"] == "jake@jake.jake"
      assert json["username"] == "jake"
      assert json["image"] == nil
      assert json["bio"] == nil
    end

    @tag :web
    test "should not create user and render errors when data is invalid", %{conn: conn} do
      conn = post conn, Routes.user_path(conn, :create), user: build(:user, username: "")
      assert json_response(conn, 422)["errors"] == %{
        "detail" => "Unprocessable Entity"
      }
    end

    @tag :web
    test "should not create user and render errors when username has been taken", %{conn: conn} do
      # register a user
      {:ok, _user} = user_fixture(:user)

      # attempt to register the same username
      conn = post conn, Routes.user_path(conn, :create), user: build(:user, email: "jake2@jake.jake")
      assert json_response(conn, 422)["errors"] == %{
        "detail" => "Unprocessable Entity"
      }
    end
  end
end
