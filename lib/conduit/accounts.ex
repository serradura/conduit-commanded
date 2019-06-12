defmodule Conduit.Accounts do
  @moduledoc """
  The Accounts context.
  """

  alias Conduit.Accounts.Commands.RegisterUser
  alias Conduit.Accounts.Projections.User
  alias Conduit.Router
  alias Conduit.Repo

  def get_user(%RegisterUser{user_uuid: uuid}),
  do: get_user(uuid)

  def get_user(uuid),
  do: get_user_by(uuid: uuid)

  def get_user_by_username(value)
  when is_binary(value),
  do:  get_user_by(username: String.downcase(value))

  def get_user_by_email(value)
  when is_binary(value),
  do:  get_user_by(email: String.downcase(value))

  defp get_user_by(option) do
    case Repo.get_by(User, option) do
      nil  -> {:error, :not_found}
      user -> {:ok, user}
    end
  end

  def register_user(attrs \\ %{}) do
    with cmd <- RegisterUser.build(attrs),
         :ok <- Router.dispatch(cmd, consistency: :strong) do
      get_user(cmd)
    else
      reply -> reply
    end
  end
end
