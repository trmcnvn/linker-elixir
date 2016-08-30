defmodule Linker.Repo.Migrations.CreateLink do
  use Ecto.Migration

  def change do
    create table(:links) do
      add :short_id, :string
      add :external_url, :string

      timestamps()
    end
    create unique_index(:links, [:short_id])
    create unique_index(:links, [:external_url])

  end
end
