defmodule ConduitWeb.Auth.JWT do
  alias ConduitWeb.Auth.Guardian

  @pattern ~r/\A[A-Za-z0-9-_=]+\.[A-Za-z0-9-_=]+\.?[A-Za-z0-9-_.+\/=]*\z/

  def valid?(value),
  do: Regex.match?(@pattern, value)

  def generate_jwt(resource) do
    case Guardian.encode_and_sign(resource) do
      {:ok, jwt, _full_claims} -> {:ok, jwt}
    end
  end
end
