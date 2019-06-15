defmodule ConduitWeb.CurrentUserController do
  use ConduitWeb, :controller
  use ConduitWeb.CurrentUser

  alias ConduitWeb.Auth.Guardian

  action_fallback ConduitWeb.FallbackController

  def index(conn, _params, current_user) do
    jwt = Guardian.Plug.current_token(conn)

    conn
    |> put_status(:ok)
    |> put_view(ConduitWeb.UserView)
    |> render("show.json", user: current_user, jwt: jwt)
  end
end
