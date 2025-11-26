defmodule FilmChecklist.Checklists.ChecklistResponse do
  use Ecto.Schema
  import Ecto.Changeset

  schema "checklist_responses" do
    field :value, :string
    field :user_id, :id
    belongs_to :checklist, FilmChecklist.Checklists.Checklist
    belongs_to :checklist_item, FilmChecklist.Checklists.ChecklistItem

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(checklist_response, attrs, user_scope) do
    checklist_response
    |> cast(attrs, [:value])
    |> validate_required([:value])
    |> put_change(:user_id, user_scope.user.id)
  end
end
