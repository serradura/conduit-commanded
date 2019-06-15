defmodule ConduitWeb.UserController do
  use ConduitWeb, :controller

  alias Conduit.Accounts
  alias ConduitWeb.Auth.Guardian

  action_fallback ConduitWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    with {:ok, attrs} <- attrs_to_register(user_params),
         {:ok, user}  <- Accounts.register_user(attrs),
         {:ok, jwt}   <- generate_jwt(user) do
      conn
      |> put_status(:created)
      |> render("show.json", user: user, jwt: jwt)
    end
  end

  def current(conn, _params) do
    jwt = Guardian.Plug.current_token(conn)
    user = Guardian.Plug.current_resource(conn)

    conn
    |> put_status(:ok)
    |> render("show.json", user: user, jwt: jwt)
  end

  defp attrs_to_register(params) do
    {:ok, %{
      email: params["email"],
      username: params["username"],
      password: params["password"],
      image: params["image"],
      bio: params["bio"],
    }}
  end
end
