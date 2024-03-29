defmodule ConduitWeb.Router do
  use ConduitWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug ConduitWeb.Auth.Pipeline
  end

  scope "/api", ConduitWeb do
    pipe_through :api

    resources "/users", UserController, only: [:create]
    resources "/users/login", SessionController, only: [:create]
    resources "/articles", ArticleController, except: [:create, :new, :edit]
  end

  scope "/api", ConduitWeb do
    pipe_through [:api, :auth]

    resources "/user", CurrentUserController, only: [:index]
    resources "/articles", ArticleController, only: [:create]
  end
end
