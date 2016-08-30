defmodule Linker.Link do
  use Linker.Web, :model

  schema "links" do
    field :short_id, :string
    field :external_url, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(generate_short_id(params), [:short_id, :external_url])
    |> validate_required([:external_url])
    |> validate_url(:external_url)
    |> unique_constraint(:short_id)
    |> unique_constraint(:external_url)
  end

  defp generate_short_id(params) do
    if Map.has_key?(params, "external_url") && !Map.has_key?(params, "short_id") do
      short_id = ShortLink.generate(params["external_url"])
      Map.put(params, "short_id", short_id)
    else
      params
    end
  end

  defp validate_url(changeset, field) do
    validate_change(changeset, field, fn(field, url) ->
      case :http_uri.parse(String.to_char_list(url)) do
        {:ok, _} -> []
        {:error, _} -> [{field, "is not a valid url"}]
      end
    end)
  end
end
