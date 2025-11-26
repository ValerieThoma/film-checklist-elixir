defmodule FilmChecklist.Repo.Migrations.CreateFilms do
  use Ecto.Migration

  def change do
    create table(:films) do
      add :title, :string
      add :year, :integer
      add :poster_url, :string
      add :user_id, references(:users, type: :id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:films, [:user_id])
  end
end
