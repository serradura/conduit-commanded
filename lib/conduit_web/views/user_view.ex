defmodule ConduitWeb.UserView do
  use ConduitWeb, :view
  alias ConduitWeb.UserView

  def render("index.json", %{users: users}) do
    %{user: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user, jwt: jwt}) do
    user_with_token =
      user
      |> render_one(UserView, "user.json")
      |> Map.merge(%{token: jwt})

    %{user: user_with_token}
  end

  def render("user.json", %{user: user}) do
    %{email: user.email,
      username: user.username,
      image: user.image,
      bio: user.bio}
  end
end
