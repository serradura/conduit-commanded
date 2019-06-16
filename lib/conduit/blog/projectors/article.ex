defmodule Conduit.Blog.Projectors.Article do
  use Commanded.Projections.Ecto,
    name: "Blog.Projectors.Article",
    consistency: :strong

  alias Conduit.Blog.Events.{ArticlePublished, AuthorCreated}
  alias Conduit.Blog.Projections.{Article, Author}
  alias Conduit.{Blog, Repo}

  project %AuthorCreated{} = author, fn multi ->
    Ecto.Multi.insert(multi, :author, %Author{
      uuid: author.author_uuid,
      user_uuid: author.user_uuid,
      username: author.username,
      bio: nil,
      image: nil,
    })
  end

  project %ArticlePublished{author_uuid: uuid} = published, metadata, fn multi ->
    multi
    |> Ecto.Multi.run(:author, fn _repo, _changes -> Blog.get_author(uuid) end)
    |> Ecto.Multi.run(:article, fn _repo, %{author: author} ->
      Article.published(published, author, metadata)
      |> Repo.insert()
    end)
  end
end
