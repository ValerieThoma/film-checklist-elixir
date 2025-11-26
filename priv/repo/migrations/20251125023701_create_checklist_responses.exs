defmodule FilmChecklist.Repo.Migrations.CreateChecklistResponses do
  use Ecto.Migration

  def change do
    create table(:checklist_responses) do
      add :value, :string
      add :checklist_id, references(:checklists, on_delete: :nothing)
      add :checklist_item_id, references(:checklist_items, on_delete: :nothing)
      add :user_id, references(:users, type: :id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:checklist_responses, [:user_id])

    create index(:checklist_responses, [:checklist_id])
    create index(:checklist_responses, [:checklist_item_id])
  end
end
