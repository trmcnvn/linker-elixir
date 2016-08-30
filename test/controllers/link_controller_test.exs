defmodule Linker.LinkControllerTest do
  use Linker.ConnCase

  alias Linker.Link
  @valid_attrs %{external_url: "https://www.google.com", short_id: "69d2e0"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "redirects on chosen resource", %{conn: conn} do
    link = Repo.insert! Map.merge(%Link{}, @valid_attrs)
    conn = get conn, link_path(conn, :show, link)
    assert response(conn, 302)
  end

  test "previews chosen resource", %{conn: conn} do
    link = Repo.insert! Map.merge(%Link{}, @valid_attrs)
    conn = get conn, link_path(conn, :preview, link.short_id)
    assert json_response(conn, 200) == %{"short_id" => link.short_id,
      "external_url" => link.external_url,
      "inserted_at" => Ecto.DateTime.to_iso8601(link.inserted_at)}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, link_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, link_path(conn, :create), @valid_attrs
    assert json_response(conn, 201)["short_id"] == "69d2e0"
    assert Repo.get_by(Link, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, link_path(conn, :create), link: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end
end
