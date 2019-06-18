defmodule ConduitWeb.ArticleView do
  use ConduitWeb, :view
  alias ConduitWeb.ArticleView

  def render("index.json", %{articles: articles}) do
    %{articles: render_many(articles, ArticleView, "article.json")}
  end

  def render("show.json", %{article: article}) do
    %{article: render_one(article, ArticleView, "article.json")}
  end

  def render("article.json", %{article: article}) do
    %{
      slug: article.slug,
      title: article.title,
      description: article.description,
      body: article.body,
      tagList: article.tag_list,
      createdAt: NaiveDateTime.to_iso8601(article.published_at),
      updatedAt: NaiveDateTime.to_iso8601(article.updated_at),
      favoritesCount: article.favorite_count,
      favorited: false,
      author: %{
        username: article.author_username,
        bio: article.author_bio,
        image: article.author_image,
        following: false,
      },
    }
  end
end
