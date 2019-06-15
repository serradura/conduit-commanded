defmodule Conduit.BlogTest do
  use Conduit.DataCase

  alias Conduit.Blog

  describe "articles" do
    alias Conduit.Blog.Article

    @valid_attrs %{author_bio: "some author_bio", author_image: "some author_image", author_username: "some author_username", author_uuid: "some author_uuid", body: "some body", description: "some description", favorite_count: 42, published_at: ~N[2010-04-17 14:00:00], slug: "some slug", tag_list: [], title: "some title"}
    @update_attrs %{author_bio: "some updated author_bio", author_image: "some updated author_image", author_username: "some updated author_username", author_uuid: "some updated author_uuid", body: "some updated body", description: "some updated description", favorite_count: 43, published_at: ~N[2011-05-18 15:01:01], slug: "some updated slug", tag_list: [], title: "some updated title"}
    @invalid_attrs %{author_bio: nil, author_image: nil, author_username: nil, author_uuid: nil, body: nil, description: nil, favorite_count: nil, published_at: nil, slug: nil, tag_list: nil, title: nil}

    def article_fixture(attrs \\ %{}) do
      {:ok, article} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Blog.create_article()

      article
    end

    test "list_articles/0 returns all articles" do
      article = article_fixture()
      refute Blog.list_articles() == [article]
    end

    test "get_article!/1 returns the article with given id" do
      article = article_fixture()
      assert Blog.get_article!(article.id) == article
    end

    test "create_article/1 with valid data creates a article" do
      assert {:ok, %Article{} = article} = Blog.create_article(@valid_attrs)
      assert article.author_bio == "some author_bio"
      assert article.author_image == "some author_image"
      assert article.author_username == "some author_username"
      assert article.author_uuid == "some author_uuid"
      assert article.body == "some body"
      assert article.description == "some description"
      assert article.favorite_count == 42
      assert article.published_at == ~N[2010-04-17 14:00:00]
      assert article.slug == "some slug"
      assert article.tag_list == []
      assert article.title == "some title"
    end

    test "create_article/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Blog.create_article(@invalid_attrs)
    end

    test "update_article/2 with valid data updates the article" do
      article = article_fixture()
      assert {:ok, %Article{} = article} = Blog.update_article(article, @update_attrs)
      assert article.author_bio == "some updated author_bio"
      assert article.author_image == "some updated author_image"
      assert article.author_username == "some updated author_username"
      assert article.author_uuid == "some updated author_uuid"
      assert article.body == "some updated body"
      assert article.description == "some updated description"
      assert article.favorite_count == 43
      assert article.published_at == ~N[2011-05-18 15:01:01]
      assert article.slug == "some updated slug"
      assert article.tag_list == []
      assert article.title == "some updated title"
    end

    test "update_article/2 with invalid data returns error changeset" do
      article = article_fixture()
      assert {:error, %Ecto.Changeset{}} = Blog.update_article(article, @invalid_attrs)
      assert article == Blog.get_article!(article.id)
    end

    test "delete_article/1 deletes the article" do
      article = article_fixture()
      assert {:ok, %Article{}} = Blog.delete_article(article)
      assert_raise Ecto.NoResultsError, fn -> Blog.get_article!(article.id) end
    end

    test "change_article/1 returns a article changeset" do
      article = article_fixture()
      assert %Ecto.Changeset{} = Blog.change_article(article)
    end
  end
end
