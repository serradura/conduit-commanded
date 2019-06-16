defmodule ConduitWeb.ArticleControllerTest do
  use ConduitWeb.ConnCase

  alias Conduit.Blog.Projections.Article

  import Conduit.Factory
  import Conduit.Fixture
  import ConduitWeb.ConnHelpers

  @update_attrs %{
    author_bio: "some updated author_bio",
    author_image: "some updated author_image",
    author_username: "some updated author_username",
    author_uuid: "some updated author_uuid",
    body: "some updated body",
    description: "some updated description",
    favorite_count: 43,
    published_at: ~N[2011-05-18 15:01:01],
    slug: "some updated slug",
    tag_list: [],
    title: "some updated title"
  }
  @invalid_attrs %{author_bio: nil, author_image: nil, author_username: nil, author_uuid: nil, body: nil, description: nil, favorite_count: nil, published_at: nil, slug: nil, tag_list: nil, title: nil}

  defp create_article(_) do
    {:ok, author}  = fixture(:author)
    {:ok, article} = fixture(:article, author: author, title: "some title")

    [article: article]
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all articles", %{conn: conn} do
      conn = get(conn, Routes.article_path(conn, :index))
      refute json_response(conn, 200)["article"] == []
    end
  end

  describe "update article" do
    setup [:create_article]

    test "renders article when data is valid", %{conn: conn, article: %Article{uuid: uuid} = article} do
      conn = put(conn, Routes.article_path(conn, :update, article), article: @update_attrs)

      conn = get(conn, Routes.article_path(conn, :show, uuid))

      json = json_response(conn, 200)["article"]
      created_at = json["createdAt"]
      updated_at = json["updatedAt"]

      assert json = %{
        "slug" => "some-updated-title",
        "title" => "some updated title",
        "description" => "some updated description",
        "body" => "some updated body",
        "tagList" => [],
        "createdAt" => created_at,
        "updatedAt" => updated_at,
        "favorited" => false,
        "favoritesCount" => 43,
        "author" => %{
          "username" => "some updated author_username",
          "bio" => "some updated author_bio",
          "image" => "some updated author_image",
          "following" => false,
        }
      }
    end

    test "renders errors when data is invalid", %{conn: conn, article: article} do
      conn = put(conn, Routes.article_path(conn, :update, article), article: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete article" do
    setup [:create_article]

    test "deletes chosen article", %{conn: conn, article: article} do
      conn = delete(conn, Routes.article_path(conn, :delete, article))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.article_path(conn, :show, article))
      end
    end
  end

  describe "publish article" do
    @tag :web
    test "should create and return article when data is valid", %{conn: conn} do
      conn = post authenticated_conn(conn), Routes.article_path(conn, :create), article: build(:article)
      json = json_response(conn, 201)["article"]
      created_at = json["createdAt"]
      updated_at = json["updatedAt"]

      assert json == %{
        "slug" => "how-to-train-your-dragon",
        "title" => "How to train your dragon",
        "description" => "Ever wonder how?",
        "body" => "You have to believe",
        "tagList" => ["dragons", "training"],
        "createdAt" => created_at,
        "updatedAt" => updated_at,
        "favorited" => false,
        "favoritesCount" => 0,
        "author" => %{
          "username" => "jake",
          "bio" => nil,
          "image" => nil,
          "following" => false,
        }
      }
      refute created_at == ""
      refute updated_at == ""
    end
  end
end
