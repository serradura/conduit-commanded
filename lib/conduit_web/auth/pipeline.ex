defmodule ConduitWeb.Auth.Pipeline do
  use Guardian.Plug.Pipeline, otp_app: :conduit,
    module: ConduitWeb.Auth.Guardian,
    error_handler: ConduitWeb.Auth.ErrorHandler

  plug Guardian.Plug.VerifyHeader, realm: "Token"
  plug Guardian.Plug.LoadResource, allow_blank: true
end
