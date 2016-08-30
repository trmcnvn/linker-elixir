defmodule Linker.LinkController do
  use Linker.Web, :controller

  plug :link_exists when action in [:create]

  alias Linker.Link

  def create(conn, link_params) do
    changeset = Link.changeset(%Link{}, link_params)

    case Repo.insert(changeset) do
      {:ok, link} ->
        _created(conn, link)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Linker.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    link = Repo.get!(Link, id)
    conn
    |> put_resp_header("location", link.external_url)
    |> send_resp(:found, "")
  end

  def preview(conn, %{"id" => id}) do
    link = Repo.one!(from l in Link, where: l.short_id == ^id)
    render(conn, "preview.json", link)
  end

  defp link_exists(conn, _) do
    if Map.has_key?(conn.params, "external_url") do
      link = Repo.one(from l in Link, where: l.external_url == ^conn.params["external_url"])
      unless is_nil(link), do: _created(conn, link)
    end
    if Map.has_key?(conn.params, "short_id") do
      link = Repo.one(from l in Link, where: l.short_id == ^conn.params["short_id"])
      unless is_nil(link), do: _created(conn, link)
    end
    conn
  end

  defp _created(conn, link) do
    conn
    |> put_status(:created)
    |> render("preview.json", link)
  end
end
