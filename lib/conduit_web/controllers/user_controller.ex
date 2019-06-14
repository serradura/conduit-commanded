defmodule ConduitWeb.UserController do
  use ConduitWeb, :controller

  alias Conduit.Accounts
  alias Conduit.Accounts.Projections.User

  action_fallback ConduitWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    with {:ok, attrs} <- attrs_to_register(user_params),
         {:ok, user}  <- Accounts.register_user(attrs) do
      conn
      |> put_status(:created)
      |> render("show.json", user: user)
    end
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
