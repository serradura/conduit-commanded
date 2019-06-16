defmodule Conduit.Blog.Commands.PublishArticle do
  defstruct [
    author_uuid: nil,
    article_uuid: nil,
    slug: "",
    body: "",
    title: "",
    description: "",
    tag_list: [],
  ]

  use ExConstructor
  use Vex.Struct

  alias Conduit.Blog
  alias Conduit.Blog.Projections.Author
  alias Conduit.Blog.Commands.PublishArticle

  validates :author_uuid, uuid: true
  validates :article_uuid, uuid: true
  validates :slug, presence: true, uniqueness: [
                     prerequisite: :slug,
                     finder: &Blog.get_article_by_slug/1
                   ]
  validates :body, presence: true, string: true
  validates :title, presence: true, string: true
  validates :description, presence: true, string: true
  validates :tag_list, by: &is_list/1

  def build(%{} = attrs, %Author{} = author) do
    attrs
    |> new()
    |> assign_article_uuid()
    |> assign_author(author)
    |> generate_url_slug()
  end

  defp assign_article_uuid(%PublishArticle{article_uuid: nil} = cmd),
  do:  %PublishArticle{cmd | article_uuid: UUID.uuid4()}

  defp assign_article_uuid(%PublishArticle{article_uuid: _} = cmd),
  do:  cmd

  def assign_author(%PublishArticle{} = cmd, %Author{uuid: uuid}),
  do: %PublishArticle{cmd | author_uuid: uuid}

  def generate_url_slug(%PublishArticle{title: title} = cmd) do
    case Slugger.slugify_downcase(title) do
      {:ok, slug} -> %PublishArticle{cmd | slug: slug}
      _ -> cmd
    end
  end
end

defimpl Conduit.Support.Middleware.Uniqueness.UniqueFields, for: Conduit.Blog.Commands.PublishArticle do
  def unique(_command), do: [
    {:slug, "has already been taken"},
  ]
end
