defmodule FilmChecklist.Films.Film do
  use Ecto.Schema
  import Ecto.Changeset

  schema "films" do
    field :title, :string
    field :year, :integer
    field :poster_url, :string
    field :user_id, :id
    
    has_many :checklists, FilmChecklist.Checklists.Checklist

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(film, attrs, user_scope) do
    film
    |> cast(attrs, [:title, :year, :poster_url])
    |> validate_required([:title, :year, :poster_url])
    |> put_change(:user_id, user_scope.user.id)
  end
end
