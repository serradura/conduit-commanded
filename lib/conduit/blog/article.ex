defmodule Conduit.Blog.Article do
  use Ecto.Schema
  import Ecto.Changeset

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
    |> cast(attrs, [:slug, :title, :description, :body, :tag_list, :favorite_count, :published_at, :author_uuid, :author_username, :author_bio, :author_image])
    |> validate_required([:slug, :title, :description, :body, :tag_list, :favorite_count, :published_at, :author_uuid, :author_username, :author_bio, :author_image])
  end
end
