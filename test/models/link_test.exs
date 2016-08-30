defmodule Linker.LinkTest do
  use Linker.ModelCase

  alias Linker.Link

  @valid_attrs %{external_url: "https://www.google.com", short_id: "69d2e0"}
  @invalid_attrs %{external_url: "not-a-url"}

  test "changeset with valid attributes" do
    changeset = Link.changeset(%Link{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Link.changeset(%Link{}, @invalid_attrs)
    refute changeset.valid?
  end
end
