defmodule Conduit.Auth do
  @moduledoc """
  Authentication using the bcrypt password hashing function.
  """

  def hash_password(password),
  do: Bcrypt.hash_pwd_salt(password)

  def validate_password(password, hash),
  do: Bcrypt.verify_pass(password, hash)
end
