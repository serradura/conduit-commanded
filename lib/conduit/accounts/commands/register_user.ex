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
    |> assign_user_uuid()
    |> hash_password()
    |> downcase_attr(:email)
    |> downcase_attr(:username)
    |> new()
  end

  defp assign_user_uuid(%{user_uuid: _} = attrs), do: attrs
  defp assign_user_uuid(%{} = attrs),
  do:  Map.put(attrs, :user_uuid, UUID.uuid4())

  defp downcase_attr(%{} = attrs, key)
  when is_atom(key),
  do:  %{attrs | key => String.downcase(attrs[key]) }

  defp downcase_attr(%{} = attrs, _), do: attrs

  defp hash_password(%{password: password} = attrs) do
    %{attrs | password: nil}
    |> Map.put(:hashed_password, Auth.hash_password(password))
  end
end

defimpl Conduit.Support.Middleware.Uniqueness.UniqueFields, for: Conduit.Accounts.Commands.RegisterUser do
  def unique(_command), do: [
    {:email, "has already been taken"},
    {:username, "has already been taken"},
  ]
end
