defmodule Conduit.Blog do
  @moduledoc """
  The Blog context.
  """

  import Ecto.Query, warn: false

  alias Conduit.Blog.Projections.Article
  alias Conduit.Blog.Projections.Author
  alias Conduit.Blog.Commands.{CreateAuthor, PublishArticle}
  alias Conduit.{Repo,Router}

  def list_articles,
  do: Repo.all(Article)

  def get_article!(uuid),
  do: Repo.get!(Article, uuid)

  def get_article(uuid),
  do: get_by(Article, uuid: uuid)

  def create_article(attrs \\ %{}) do
    %Article{}
    |> Article.changeset(attrs)
    |> Repo.insert()
  end

  def update_article(%Article{} = article, attrs) do
    article
    |> Article.changeset(attrs)
    |> Repo.update()
  end

  def delete_article(%Article{} = article) do
    Repo.delete(article)
  end

  def change_article(%Article{} = article) do
    Article.changeset(article, %{})
  end

  def get_article_by_slug(slug),
  do: get_by(Article, slug: slug)

  @doc """
  Publishes an article by the given author.
  """
  def publish_article(%Author{} = author, attrs \\ %{}) do
    with publish_article <- PublishArticle.build(attrs, author),
        :ok              <- Router.dispatch(publish_article, consistency: :strong) do
      get_article(publish_article.article_uuid)
    else
      reply -> reply
    end
  end

  def get_author(uuid),
  do: get_by(Author, uuid: uuid)

  @doc """
  Create an author.
  An author shares the same uuid as the user, but with a different prefix.
  """
  def create_author(%{user_uuid: uuid} = attrs) do
    with create_author <- CreateAuthor.build(attrs),
         :ok           <- Router.dispatch(create_author, consistency: :strong) do
      get_author(uuid)
    else
      reply -> reply
    end
  end

  defp get_by(schema, options) when is_list(options) do
    case Repo.get_by(schema, options) do
      nil -> {:error, :not_found}
      projection -> {:ok, projection}
    end
  end
end
