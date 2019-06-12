defmodule Conduit.Accounts.Commands.RegisterUser do
  defstruct [
    :user_uuid,
    :username,
    :email,
    :password,
    :hashed_password,
  ]

  use ExConstructor
  use Vex.Struct

  alias Conduit.Accounts

  validates :email, presence: true, email: true
  validates :username, string: true, uniqueness: [
    prerequisite: :presence, finder: &Accounts.get_user_by_username/1
  ]
  validates :user_uuid, uuid: true
  validates :hashed_password, presence: true, string: true

  def build(attrs) when is_map(attrs) do
    uuid = UUID.uuid4()

    attrs
    |> Map.put(:user_uuid, uuid)
    |> new()
  end
end

defimpl Conduit.Support.Middleware.Uniqueness.UniqueFields, for: Conduit.Accounts.Commands.RegisterUser do
  def unique(_command), do: [
    {:username, "has already been taken"},
  ]
end
