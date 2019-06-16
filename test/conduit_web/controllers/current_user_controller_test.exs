defmodule ConduitWeb.CurrentUserControllerTest do
  use ConduitWeb.ConnCase

  import ConduitWeb.ConnHelpers

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "get current user" do
    @tag :web
    test "should return user when authenticated", %{conn: conn} do
      conn = get authenticated_conn(conn), Routes.current_user_path(conn, :index)
      json = json_response(conn, 200)["user"]
      token = json["token"]

      assert json == %{
        "bio" => nil,
        "email" => "jake@jake.jake",
        "token" => token,
        "image" => nil,
        "username" => "jake",
      }
      assert ConduitWeb.Auth.JWT.valid?(token)
    end

    @tag :web
    test "should not return user when unauthenticated", %{conn: conn} do
      conn = get conn, Routes.current_user_path(conn, :index)
      body = response(conn, 401)

      assert body == "{\"message\":\"unauthenticated\"}"
    end
  end
end
