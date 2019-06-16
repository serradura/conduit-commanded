defmodule Conduit.Blog.Workflows.CreateAuthorFromUser do
  use Commanded.Event.Handler,
    name: "Blog.Workflows.CreateAuthorFromUser",
    consistency: :strong

  alias Conduit.Accounts.Events.UserRegistered
  alias Conduit.Blog

  def handle(%UserRegistered{user_uuid: user_uuid, username: username}, _metadata) do
    with user_attrs     <- %{user_uuid: user_uuid, username: username},
         {:ok, _author} <- Blog.create_author(user_attrs) do
      :ok
    else
      reply -> reply
    end
  end
end
