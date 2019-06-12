defmodule ConduitWeb.UserView do
  use ConduitWeb, :view
  alias ConduitWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{uuid: user.uuid,
      username: user.username,
      email: user.email,
      bio: user.bio,
      image: user.image}
  end
end
