defmodule ConduitWeb.ConnHelpers do
  import Plug.Conn
  import Conduit.Factory

  def authenticated_conn(conn) do
    with {:ok, user} <- Conduit.Accounts.register_user(build(:user)),
         {:ok, jwt}  <- ConduitWeb.Auth.JWT.generate_jwt(user),
    do:  put_req_header(conn, "authorization", "Token " <> jwt)
  end
end
