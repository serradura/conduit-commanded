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
    |> assign_author_uuid(user_uuid)
  end

  defp assign_author_uuid(%CreateAuthor{} = cmd, user_uuid),
  do:  %CreateAuthor{cmd | author_uuid: user_uuid}
end
