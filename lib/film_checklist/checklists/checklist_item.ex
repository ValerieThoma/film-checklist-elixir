defmodule FilmChecklist.Checklists.ChecklistItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "checklist_items" do
    field :name, :string
    field :section, :string
    field :point_value, :decimal
    field :order_position, :integer
    field :response_type, :string
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(checklist_item, attrs, user_scope) do
    checklist_item
    |> cast(attrs, [:name, :section, :point_value, :order_position, :response_type])
    |> validate_required([:name, :section, :point_value, :order_position, :response_type])
    |> put_change(:user_id, user_scope.user.id)
  end
end
