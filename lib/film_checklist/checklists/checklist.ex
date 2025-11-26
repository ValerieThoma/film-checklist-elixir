defmodule FilmChecklist.Checklists.Checklist do
  use Ecto.Schema
  import Ecto.Changeset
  
  alias FilmChecklist.Repo
  
  alias FilmChecklist.Checklists.Checklist
  alias FilmChecklist.Checklists.ChecklistItem
  alias FilmChecklist.Checklists.ChecklistResponse

  schema "checklists" do
    field :completed, :boolean, default: false
    field :total_score, :decimal
    
    belongs_to :user, FilmChecklist.Accounts.User
    belongs_to :film, FilmChecklist.Films.Film
    has_many :checklist_responses, FilmChecklist.Checklists.ChecklistResponse

    timestamps(type: :utc_datetime)
  end

  def list_user_checklists(user_id) do
  Repo.all(
    from c in Checklist,
    where: c.user_id == ^user_id,
    preload: [:film],
    order_by: [desc: c.inserted_at]
  )
end
# All the functions to add to lib/film_checklist/checklists.ex:

def list_user_checklists(user_id) do
  Repo.all(
    from c in Checklist,
    where: c.user_id == ^user_id,
    preload: [:film],
    order_by: [desc: c.inserted_at]
  )
end

def list_checklist_items do
  Repo.all(from i in ChecklistItem, order_by: i.order_position)
end

def list_checklist_responses(checklist_id) do
  Repo.all(from r in ChecklistResponse, where: r.checklist_id == ^checklist_id)
end

def create_checklist_response(attrs \\ %{}) do
  %ChecklistResponse{}
  |> ChecklistResponse.changeset(attrs)
  |> Repo.insert()
end

def update_checklist_response(%ChecklistResponse{} = response, attrs) do
  response
  |> ChecklistResponse.changeset(attrs)
  |> Repo.update()
end

def get_checklist!(id) do
  Repo.get!(Checklist, id)
  |> Repo.preload([:film, :user])
end

def update_checklist(%Checklist{} = checklist, attrs) do
  checklist
  |> Checklist.changeset(attrs)
  |> Repo.update()
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