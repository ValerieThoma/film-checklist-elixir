defmodule FilmChecklist.Repo.Migrations.CreateChecklistItems do
  use Ecto.Migration

  def change do
    create table(:checklist_items) do
      add :name, :string
      add :section, :string
      add :point_value, :decimal, precision: 10, scale: 2
      add :order_position, :integer
      add :response_type, :string
      add :user_id, references(:users, type: :id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:checklist_items, [:user_id])
  end
end
