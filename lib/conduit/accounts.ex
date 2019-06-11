defmodule Conduit.Accounts do
  @moduledoc """
  The Accounts context.
  """

  alias Conduit.Accounts.Commands.RegisterUser
  alias Conduit.Accounts.Projections.User
  alias Conduit.Router
  alias Conduit.Repo

  def get_user(uuid) do
    case Repo.get(User, uuid) do
      nil -> {:error, :not_found}
      projection -> {:ok, projection}
    end
  end

  def register_user(attrs \\ %{}) do
    uuid = UUID.uuid4()

    register_user =
      attrs
      |> Map.put(:user_uuid, uuid)
      |> RegisterUser.new()

    with :ok <- Router.dispatch(register_user, consistency: :strong) do
      get_user(uuid)
    else
      reply -> reply
    end
  end
end
