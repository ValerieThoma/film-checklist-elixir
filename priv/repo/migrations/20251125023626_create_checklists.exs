defmodule FilmChecklist.Repo.Migrations.CreateChecklists do
  use Ecto.Migration

  def change do
    create table(:checklists) do
      add :completed, :boolean, default: false, null: false
      add :total_score, :integer
      add :user_id, references(:users, type: :id, on_delete: :delete_all)
      add :film_id, references(:films, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:checklists, [:user_id])
    create index(:checklists, [:film_id])
  end
end
