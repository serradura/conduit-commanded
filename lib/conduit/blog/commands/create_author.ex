defmodule Conduit.Blog.Commands.CreateAuthor do
  defstruct [
    :author_uuid,
    :user_uuid,
    :username
  ]

  use ExConstructor
  use Vex.Struct

  alias Conduit.Blog.Commands.CreateAuthor

  validates :author_uuid, uuid: true
  validates :user_uuid, uuid: true
  validates :username, username: true

  @doc """
  Assign a unique identity
  """
  def build(%{user_uuid: user_uuid} = attrs) do
    attrs
    |> new()
    |> assign_uuid(user_uuid)
  end

  defp assign_uuid(create_author, user_uuid),
  do:  %CreateAuthor{create_author | author_uuid: user_uuid}
end
