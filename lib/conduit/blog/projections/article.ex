defmodule Conduit.Blog.Projections.Article do
  @derive {Phoenix.Param, key: :uuid}

  use Ecto.Schema
  import Ecto.Changeset

  alias Conduit.Blog.Events.ArticlePublished
  alias Conduit.Blog.Projections.{Article, Author}

  @primary_key {:uuid, :binary_id, autogenerate: false}

  schema "blog_articles" do
    field :author_bio, :string
    field :author_image, :string
    field :author_username, :string
    field :author_uuid, :binary
    field :body, :string
    field :description, :string
    field :favorite_count, :integer
    field :published_at, :naive_datetime
    field :slug, :string
    field :tag_list, {:array, :string}
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(article, attrs) do
    article
    |> cast(attrs, [
      :uuid, :slug, :title, :description, :body, :tag_list, :favorite_count,
      :published_at, :author_uuid, :author_username, :author_bio, :author_image
    ])
    |> validate_required([:slug, :title, :description, :body, :tag_list])
  end

  def published(%ArticlePublished{} = published, %Author{} = author, metadata) do
    published_at = NaiveDateTime.truncate(metadata.created_at, :second)

    %Article{
      uuid: published.article_uuid,
      slug: published.slug,
      title: published.title,
      description: published.description,
      body: published.body,
      tag_list: published.tag_list,
      favorite_count: 0,
      published_at: published_at,
      author_uuid: author.uuid,
      author_username: author.username,
      author_bio: author.bio,
      author_image: author.image
    }
  end
end
