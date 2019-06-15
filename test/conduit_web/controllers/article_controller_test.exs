defmodule ConduitWeb.ArticleControllerTest do
  use ConduitWeb.ConnCase

  alias Conduit.Blog
  alias Conduit.Blog.Article

  @create_attrs %{
    author_bio: "some author_bio",
    author_image: "some author_image",
    author_username: "some author_username",
    author_uuid: "some author_uuid",
    body: "some body",
    description: "some description",
    favorite_count: 42,
    published_at: ~N[2010-04-17 14:00:00],
    slug: "some slug",
    tag_list: [],
    title: "some title"
  }
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

  def fixture(:article) do
    {:ok, article} = Blog.create_article(@create_attrs)
    article
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all articles", %{conn: conn} do
      conn = get(conn, Routes.article_path(conn, :index))
      refute json_response(conn, 200)["data"] == []
    end
  end

  describe "create article" do
    test "renders article when data is valid", %{conn: conn} do
      conn = post(conn, Routes.article_path(conn, :create), article: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.article_path(conn, :show, id))

      assert %{
               "id" => id,
               "author_bio" => "some author_bio",
               "author_image" => "some author_image",
               "author_username" => "some author_username",
               "author_uuid" => "some author_uuid",
               "body" => "some body",
               "description" => "some description",
               "favorite_count" => 42,
               "published_at" => "2010-04-17T14:00:00",
               "slug" => "some slug",
               "tag_list" => [],
               "title" => "some title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.article_path(conn, :create), article: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update article" do
    setup [:create_article]

    test "renders article when data is valid", %{conn: conn, article: %Article{id: id} = article} do
      conn = put(conn, Routes.article_path(conn, :update, article), article: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.article_path(conn, :show, id))

      assert %{
               "id" => id,
               "author_bio" => "some updated author_bio",
               "author_image" => "some updated author_image",
               "author_username" => "some updated author_username",
               "author_uuid" => "some updated author_uuid",
               "body" => "some updated body",
               "description" => "some updated description",
               "favorite_count" => 43,
               "published_at" => "2011-05-18T15:01:01",
               "slug" => "some updated slug",
               "tag_list" => [],
               "title" => "some updated title"
             } = json_response(conn, 200)["data"]
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

  defp create_article(_) do
    article = fixture(:article)
    {:ok, article: article}
  end
end
