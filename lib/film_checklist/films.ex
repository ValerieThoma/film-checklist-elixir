defmodule FilmChecklist.Films do
  @moduledoc """
  The Films context.
  """

  import Ecto.Query, warn: false
  alias FilmChecklist.Repo

  alias FilmChecklist.Films.Film

  @doc """
  Returns the list of films.

  ## Examples

      iex> list_films()
      [%Film{}, ...]

  """
  def list_films do
    Repo.all(Film)
  end

  @doc """
  Gets a single film.

  Raises `Ecto.NoResultsError` if the Film does not exist.

  ## Examples

      iex> get_film!(123)
      %Film{}

      iex> get_film!(456)
      ** (Ecto.NoResultsError)

  """
  def get_film!(id), do: Repo.get!(Film, id)


  alias FilmChecklist.Films.Film
  alias FilmChecklist.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any film changes.

  The broadcasted messages match the pattern:

    * {:created, %Film{}}
    * {:updated, %Film{}}
    * {:deleted, %Film{}}

  """
  def subscribe_films(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(FilmChecklist.PubSub, "user:#{key}:films")
  end

  defp broadcast_film(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(FilmChecklist.PubSub, "user:#{key}:films", message)
  end

  @doc """
  Returns the list of films.

  ## Examples

      iex> list_films(scope)
      [%Film{}, ...]

  """
  def list_films(%Scope{} = scope) do
    Repo.all_by(Film, user_id: scope.user.id)
  end

  @doc """
  Gets a single film.

  Raises `Ecto.NoResultsError` if the Film does not exist.

  ## Examples

      iex> get_film!(scope, 123)
      %Film{}

      iex> get_film!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_film!(%Scope{} = scope, id) do
    Repo.get_by!(Film, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a film.

  ## Examples

      iex> create_film(scope, %{field: value})
      {:ok, %Film{}}

      iex> create_film(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_film(%Scope{} = scope, attrs) do
    with {:ok, film = %Film{}} <-
           %Film{}
           |> Film.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast_film(scope, {:created, film})
      {:ok, film}
    end
  end

  @doc """
  Updates a film.

  ## Examples

      iex> update_film(scope, film, %{field: new_value})
      {:ok, %Film{}}

      iex> update_film(scope, film, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_film(%Scope{} = scope, %Film{} = film, attrs) do
    true = film.user_id == scope.user.id

    with {:ok, film = %Film{}} <-
           film
           |> Film.changeset(attrs, scope)
           |> Repo.update() do
      broadcast_film(scope, {:updated, film})
      {:ok, film}
    end
  end

  @doc """
  Deletes a film.

  ## Examples

      iex> delete_film(scope, film)
      {:ok, %Film{}}

      iex> delete_film(scope, film)
      {:error, %Ecto.Changeset{}}

  """
  def delete_film(%Scope{} = scope, %Film{} = film) do
    true = film.user_id == scope.user.id

    with {:ok, film = %Film{}} <-
           Repo.delete(film) do
      broadcast_film(scope, {:deleted, film})
      {:ok, film}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking film changes.

  ## Examples

      iex> change_film(scope, film, %{})
      %Ecto.Changeset{data: %Film{}}

  """
  def change_film(%Scope{} = scope, %Film{} = film, attrs) do
    if film.id && film.user_id do
      true = film.user_id == scope.user.id
    end

    Film.changeset(film, attrs, scope)
  end
end
