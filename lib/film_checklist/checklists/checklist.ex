defmodule FilmChecklist.Checklists.Checklist do
  use Ecto.Schema
  import Ecto.Changeset

  schema "checklists" do
    field :completed, :boolean, default: false
    field :total_score, :integer, default: 0

    belongs_to :user, FilmChecklist.Accounts.User
    belongs_to :film, FilmChecklist.Films.Film
    has_many :checklist_responses, FilmChecklist.Checklists.ChecklistResponse

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(checklist, attrs) do
    checklist
    |> cast(attrs, [:completed, :total_score, :user_id, :film_id])
    |> validate_required([:user_id, :film_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:film_id)
  end
end


