defmodule ConduitWeb.Router do
  use ConduitWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug ConduitWeb.Auth.Pipeline
  end

  scope "/api", ConduitWeb do
    pipe_through :api

    get "/user", UserController, :current
    resources "/users", UserController, only: [:create]
    resources "/users/login", SessionController, only: [:create]
  end
end
