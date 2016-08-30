defmodule Linker.LinkView do
  use Linker.Web, :view

  def render("preview.json", link) do
    %{short_id: link.short_id,
      external_url: link.external_url,
      inserted_at: link.inserted_at}
  end
end
