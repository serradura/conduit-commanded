defmodule ConduitWeb.Auth.Pipeline do
  use Guardian.Plug.Pipeline, otp_app: :conduit,
    module: ConduitWeb.Auth.Guardian,
    error_handler: ConduitWeb.Auth.ErrorHandler

  plug Guardian.Plug.VerifyHeader, realm: "Token"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
  plug :assign_current_user

  defp assign_current_user(conn, _) do
    claims = Guardian.Plug.current_claims(conn)
    current_user = Guardian.Plug.current_resource(conn)

    conn
    |> assign(:claims, claims)
    |> assign(:current_user, current_user)
  end
end
