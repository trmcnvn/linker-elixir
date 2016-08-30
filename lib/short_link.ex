defmodule ShortLink do
  @doc """
  Generates a short hex string
  """
  def generate(url) do
    UUID.uuid5(:url, url, :hex)
    |> :erlang.phash2
    |> Integer.to_string(16)
    |> String.downcase
  end
end