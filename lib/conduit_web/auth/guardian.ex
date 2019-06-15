defmodule ConduitWeb.Auth.Guardian do
  use Guardian, otp_app: :conduit

  alias Conduit.Accounts
  alias Conduit.Accounts.Projections.User

  def subject_for_token(%User{} = user, _claims),
  do: {:ok, to_string(user.uuid)}

  def subject_for_token(_, _),
  do: {:error, "Unknown resource type"}

  def resource_from_claims(%{"sub" => uuid}) do
    Accounts.get_user(uuid)
  end

  def resource_from_claims(_claims),
  do: {:error, "Unknown resource type"}
end
