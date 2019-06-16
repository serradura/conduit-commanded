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

  alias Conduit.{Accounts, Auth}
  alias Conduit.Accounts.Commands.RegisterUser

  validates :email, uniqueness: [
                      prerequisite: :email,
                      finder: &Accounts.get_user_by_email/1
                    ]
  validates :username, uniqueness: [
                         prerequisite: :username,
                         finder: &Accounts.get_user_by_username/1
                       ]
  validates :user_uuid, uuid: true
  validates :hashed_password, presence: true, string: true

  def build(%{} = attrs) do
    attrs
    |> new()
    |> assign_user_uuid()
    |> hash_password()
    |> downcase_email()
    |> downcase_username()
  end

  defp assign_user_uuid(%RegisterUser{user_uuid: nil} = cmd),
  do:  %RegisterUser{cmd | user_uuid: UUID.uuid4()}

  defp assign_user_uuid(%RegisterUser{user_uuid: _} = cmd),
  do:  cmd

  defp downcase_email(%RegisterUser{email: email} = cmd),
  do:  %RegisterUser{cmd | email: String.downcase(email)}

  defp downcase_username(%RegisterUser{username: username} = cmd),
  do:  %RegisterUser{cmd | username: String.downcase(username)}

  defp hash_password(%RegisterUser{password: password} = cmd) do
    hashed_password = Auth.hash_password(password)

    %RegisterUser{cmd | password: nil, hashed_password: hashed_password}
  end
end

defimpl Conduit.Support.Middleware.Uniqueness.UniqueFields, for: Conduit.Accounts.Commands.RegisterUser do
  def unique(_command), do: [
    {:email, "has already been taken"},
    {:username, "has already been taken"},
  ]
end
