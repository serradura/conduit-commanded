defmodule Conduit.Repo.Migrations.CreateBlogArticles do
  use Ecto.Migration

  def change do
    create table(:blog_articles) do
      add :slug, :text
      add :title, :text
      add :description, :text
      add :body, :text
      add :tag_list, {:array, :text}
      add :favorite_count, :integer
      add :published_at, :naive_datetime
      add :author_uuid, :binary
      add :author_username, :text
      add :author_bio, :text
      add :author_image, :text

      timestamps()
    end

  end
end
