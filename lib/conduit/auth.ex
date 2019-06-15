defmodule Conduit.Auth do
  @moduledoc """
  Authentication using the bcrypt password hashing function.
  """

  alias Conduit.Accounts
  alias Conduit.Accounts.Projections.User

  def hash_password(password),
  do: Bcrypt.hash_pwd_salt(password)

  def validate_password(password, hash),
  do: Bcrypt.verify_pass(password, hash)

  def authenticate(email, password) do
    with {:ok, user} <- Accounts.get_user_by_email(email),
         true        <- check_password(user, password) do
         {:ok, user}
    else
      _ -> {:error, :unauthenticated}
    end
  end

  defp check_password(%User{hashed_password: hashed_password}, password) do
    validate_password(password, hashed_password)
  end
end
