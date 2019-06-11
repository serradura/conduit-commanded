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

  validates :user_uuid, uuid: true
  validates :username, presence: true, string: true
  validates :email, presence: true, email: true
  validates :hashed_password, presence: true, string: true
end
