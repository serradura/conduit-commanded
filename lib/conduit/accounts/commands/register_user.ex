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

  validates :email, string: true,
                    presence: true,
                    uniqueness: [
                      prerequisite: :email, finder: &Accounts.get_user_by_email/1
                    ]
  validates :username, string: true,
                       format: [with: ~r/^[a-z0-9]+$/, allow_blank: true],
                       uniqueness: [
                         prerequisite: :presence, finder: &Accounts.get_user_by_username/1
                       ]
  validates :user_uuid, uuid: true
  validates :hashed_password, presence: true, string: true

  def build(attrs) when is_map(attrs) do
    uuid = UUID.uuid4()

    attrs
    |> downcase_attr(:email)
    |> downcase_attr(:username)
    |> Map.put(:user_uuid, uuid)
    |> new()
  end

  defp downcase_attr(%{username: username} = attrs, :username),
  do:  %{attrs | username: String.downcase(username)}

  defp downcase_attr(%{email: email} = attrs, :email),
  do:  %{attrs | email: String.downcase(email)}

  defp downcase_attr(%{} = attrs, _), do: attrs
end

defimpl Conduit.Support.Middleware.Uniqueness.UniqueFields, for: Conduit.Accounts.Commands.RegisterUser do
  def unique(_command), do: [
    {:email, "has already been taken"},
    {:username, "has already been taken"},
  ]
end
