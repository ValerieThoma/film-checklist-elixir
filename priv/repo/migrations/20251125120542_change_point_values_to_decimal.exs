defmodule FilmChecklist.Repo.Migrations.ChangePointValuesToDecimal do
  use Ecto.Migration

  def change do
    alter table(:checklist_items) do
      modify :point_value, :decimal, precision: 10, scale: 2
    end
    
    alter table(:checklists) do
      modify :total_score, :decimal, precision: 10, scale: 2
    end
  end
end