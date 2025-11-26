defmodule FilmChecklist.Checklists do
  @moduledoc """
  The Checklists context.
  """

  import Ecto.Query, warn: false
  alias FilmChecklist.Repo

  alias FilmChecklist.Checklists.Checklist

  @doc """
  Returns the list of checklists.

  ## Examples

      iex> list_checklists()
      [%Checklist{}, ...]

  """
  def list_checklists do
    Repo.all(Checklist)
  end

  @doc """
  Gets a single checklist.

  Raises `Ecto.NoResultsError` if the Checklist does not exist.

  ## Examples

      iex> get_checklist!(123)
      %Checklist{}

      iex> get_checklist!(456)
      ** (Ecto.NoResultsError)

  """
  def get_checklist!(id), do: Repo.get!(Checklist, id)

  @doc """
  Creates a checklist.

  ## Examples

      iex> create_checklist(%{field: value})
      {:ok, %Checklist{}}

      iex> create_checklist(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_checklist(attrs) do
    %Checklist{}
    |> Checklist.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a checklist.

  ## Examples

      iex> update_checklist(checklist, %{field: new_value})
      {:ok, %Checklist{}}

      iex> update_checklist(checklist, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_checklist(%Checklist{} = checklist, attrs) do
    checklist
    |> Checklist.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a checklist.

  ## Examples

      iex> delete_checklist(checklist)
      {:ok, %Checklist{}}

      iex> delete_checklist(checklist)
      {:error, %Ecto.Changeset{}}

  """
  def delete_checklist(%Checklist{} = checklist) do
    Repo.delete(checklist)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking checklist changes.

  ## Examples

      iex> change_checklist(checklist)
      %Ecto.Changeset{data: %Checklist{}}

  """
  def change_checklist(%Checklist{} = checklist, attrs \\ %{}) do
    Checklist.changeset(checklist, attrs)
  end

  alias FilmChecklist.Checklists.ChecklistItem

  @doc """
  Returns the list of checklist_items.

  ## Examples

      iex> list_checklist_items()
      [%ChecklistItem{}, ...]

  """
  def list_checklist_items do
    Repo.all(ChecklistItem)
  end

  @doc """
  Gets a single checklist_item.

  Raises `Ecto.NoResultsError` if the Checklist item does not exist.

  ## Examples

      iex> get_checklist_item!(123)
      %ChecklistItem{}

      iex> get_checklist_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_checklist_item!(id), do: Repo.get!(ChecklistItem, id)


  alias FilmChecklist.Checklists.ChecklistResponse

  @doc """
  Returns the list of checklist_responses.

  ## Examples

      iex> list_checklist_responses()
      [%ChecklistResponse{}, ...]

  """
  def list_checklist_responses do
    Repo.all(ChecklistResponse)
  end

  @doc """
  Gets a single checklist_response.

  Raises `Ecto.NoResultsError` if the Checklist response does not exist.

  ## Examples

      iex> get_checklist_response!(123)
      %ChecklistResponse{}

      iex> get_checklist_response!(456)
      ** (Ecto.NoResultsError)

  """
  def get_checklist_response!(id), do: Repo.get!(ChecklistResponse, id)


  alias FilmChecklist.Checklists.Checklist
  alias FilmChecklist.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any checklist changes.

  The broadcasted messages match the pattern:

    * {:created, %Checklist{}}
    * {:updated, %Checklist{}}
    * {:deleted, %Checklist{}}

  """
  def subscribe_checklists(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(FilmChecklist.PubSub, "user:#{key}:checklists")
  end

  @doc """
  Returns the list of checklists for a given user id.

  This is a helper used by some views that only have access to a user id,
  not the full `Scope` struct.
  """
  def list_user_checklists(user_id) do
    Repo.all_by(Checklist, user_id: user_id)
  end

  defp broadcast_checklist(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(FilmChecklist.PubSub, "user:#{key}:checklists", message)
  end

  @doc """
  Returns the list of checklists.

  ## Examples

      iex> list_checklists(scope)
      [%Checklist{}, ...]

  """
  def list_checklists(%Scope{} = scope) do
    Repo.all_by(Checklist, user_id: scope.user.id)
  end

  @doc """
  Gets a single checklist.

  Raises `Ecto.NoResultsError` if the Checklist does not exist.

  ## Examples

      iex> get_checklist!(scope, 123)
      %Checklist{}

      iex> get_checklist!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_checklist!(%Scope{} = scope, id) do
    Repo.get_by!(Checklist, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a checklist.

  ## Examples

      iex> create_checklist(scope, %{field: value})
      {:ok, %Checklist{}}

      iex> create_checklist(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_checklist(%Scope{} = scope, attrs) do
    attrs = Map.put(attrs, "user_id", scope.user.id)
    
    with {:ok, checklist = %Checklist{}} <-
           %Checklist{}
           |> Checklist.changeset(attrs)
           |> Repo.insert() do
      broadcast_checklist(scope, {:created, checklist})
      {:ok, checklist}
    end
  end

  @doc """
  Updates a checklist.

  ## Examples

      iex> update_checklist(scope, checklist, %{field: new_value})
      {:ok, %Checklist{}}

      iex> update_checklist(scope, checklist, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_checklist(%Scope{} = scope, %Checklist{} = checklist, attrs) do
    true = checklist.user_id == scope.user.id

    with {:ok, checklist = %Checklist{}} <-
           checklist
           |> Checklist.changeset(attrs)
           |> Repo.update() do
      broadcast_checklist(scope, {:updated, checklist})
      {:ok, checklist}
    end
  end

  @doc """
  Deletes a checklist.

  ## Examples

      iex> delete_checklist(scope, checklist)
      {:ok, %Checklist{}}

      iex> delete_checklist(scope, checklist)
      {:error, %Ecto.Changeset{}}

  """
  def delete_checklist(%Scope{} = scope, %Checklist{} = checklist) do
    true = checklist.user_id == scope.user.id

    with {:ok, checklist = %Checklist{}} <-
           Repo.delete(checklist) do
      broadcast_checklist(scope, {:deleted, checklist})
      {:ok, checklist}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking checklist changes.

  ## Examples

      iex> change_checklist(scope, checklist)
      %Ecto.Changeset{data: %Checklist{}}

  """
  def change_checklist(%Scope{} = scope, %Checklist{} = checklist, attrs) do
    if checklist.id && checklist.user_id do
      true = checklist.user_id == scope.user.id
    end

    Checklist.changeset(checklist, attrs)
  end

  alias FilmChecklist.Checklists.ChecklistItem
  alias FilmChecklist.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any checklist_item changes.

  The broadcasted messages match the pattern:

    * {:created, %ChecklistItem{}}
    * {:updated, %ChecklistItem{}}
    * {:deleted, %ChecklistItem{}}

  """
  def subscribe_checklist_items(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(FilmChecklist.PubSub, "user:#{key}:checklist_items")
  end

  defp broadcast_checklist_item(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(FilmChecklist.PubSub, "user:#{key}:checklist_items", message)
  end

  @doc """
  Returns the list of checklist_items.

  ## Examples

      iex> list_checklist_items(scope)
      [%ChecklistItem{}, ...]

  """
  def list_checklist_items(%Scope{} = scope) do
    Repo.all_by(ChecklistItem, user_id: scope.user.id)
  end

  @doc """
  Gets a single checklist_item.

  Raises `Ecto.NoResultsError` if the Checklist item does not exist.

  ## Examples

      iex> get_checklist_item!(scope, 123)
      %ChecklistItem{}

      iex> get_checklist_item!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_checklist_item!(%Scope{} = scope, id) do
    Repo.get_by!(ChecklistItem, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a checklist_item.

  ## Examples

      iex> create_checklist_item(scope, %{field: value})
      {:ok, %ChecklistItem{}}

      iex> create_checklist_item(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_checklist_item(%Scope{} = scope, attrs) do
    with {:ok, checklist_item = %ChecklistItem{}} <-
           %ChecklistItem{}
           |> ChecklistItem.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast_checklist_item(scope, {:created, checklist_item})
      {:ok, checklist_item}
    end
  end

  @doc """
  Updates a checklist_item.

  ## Examples

      iex> update_checklist_item(scope, checklist_item, %{field: new_value})
      {:ok, %ChecklistItem{}}

      iex> update_checklist_item(scope, checklist_item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_checklist_item(%Scope{} = scope, %ChecklistItem{} = checklist_item, attrs) do
    true = checklist_item.user_id == scope.user.id

    with {:ok, checklist_item = %ChecklistItem{}} <-
           checklist_item
           |> ChecklistItem.changeset(attrs, scope)
           |> Repo.update() do
      broadcast_checklist_item(scope, {:updated, checklist_item})
      {:ok, checklist_item}
    end
  end

  @doc """
  Deletes a checklist_item.

  ## Examples

      iex> delete_checklist_item(scope, checklist_item)
      {:ok, %ChecklistItem{}}

      iex> delete_checklist_item(scope, checklist_item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_checklist_item(%Scope{} = scope, %ChecklistItem{} = checklist_item) do
    true = checklist_item.user_id == scope.user.id

    with {:ok, checklist_item = %ChecklistItem{}} <-
           Repo.delete(checklist_item) do
      broadcast_checklist_item(scope, {:deleted, checklist_item})
      {:ok, checklist_item}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking checklist_item changes.

  ## Examples

      iex> change_checklist_item(scope, checklist_item, %{})
      %Ecto.Changeset{data: %ChecklistItem{}}

  """
  def change_checklist_item(%Scope{} = scope, %ChecklistItem{} = checklist_item, attrs) do
    true = checklist_item.user_id == scope.user.id

    ChecklistItem.changeset(checklist_item, attrs, scope)
  end

  alias FilmChecklist.Checklists.ChecklistResponse
  alias FilmChecklist.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any checklist_response changes.

  The broadcasted messages match the pattern:

    * {:created, %ChecklistResponse{}}
    * {:updated, %ChecklistResponse{}}
    * {:deleted, %ChecklistResponse{}}

  """
  def subscribe_checklist_responses(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(FilmChecklist.PubSub, "user:#{key}:checklist_responses")
  end

  defp broadcast_checklist_response(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(FilmChecklist.PubSub, "user:#{key}:checklist_responses", message)
  end

  @doc """
  Returns the list of checklist_responses.

  ## Examples

      iex> list_checklist_responses(scope)
      [%ChecklistResponse{}, ...]

  """
  def list_checklist_responses(%Scope{} = scope) do
    Repo.all_by(ChecklistResponse, user_id: scope.user.id)
  end

  @doc """
  Gets a single checklist_response.

  Raises `Ecto.NoResultsError` if the Checklist response does not exist.

  ## Examples

      iex> get_checklist_response!(scope, 123)
      %ChecklistResponse{}

      iex> get_checklist_response!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_checklist_response!(%Scope{} = scope, id) do
    Repo.get_by!(ChecklistResponse, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a checklist_response.

  ## Examples

      iex> create_checklist_response(scope, %{field: value})
      {:ok, %ChecklistResponse{}}

      iex> create_checklist_response(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_checklist_response(%Scope{} = scope, attrs) do
    with {:ok, checklist_response = %ChecklistResponse{}} <-
           %ChecklistResponse{}
           |> ChecklistResponse.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast_checklist_response(scope, {:created, checklist_response})
      {:ok, checklist_response}
    end
  end

  @doc """
  Updates a checklist_response.

  ## Examples

      iex> update_checklist_response(scope, checklist_response, %{field: new_value})
      {:ok, %ChecklistResponse{}}

      iex> update_checklist_response(scope, checklist_response, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_checklist_response(%Scope{} = scope, %ChecklistResponse{} = checklist_response, attrs) do
    true = checklist_response.user_id == scope.user.id

    with {:ok, checklist_response = %ChecklistResponse{}} <-
           checklist_response
           |> ChecklistResponse.changeset(attrs, scope)
           |> Repo.update() do
      broadcast_checklist_response(scope, {:updated, checklist_response})
      {:ok, checklist_response}
    end
  end

  @doc """
  Deletes a checklist_response.

  ## Examples

      iex> delete_checklist_response(scope, checklist_response)
      {:ok, %ChecklistResponse{}}

      iex> delete_checklist_response(scope, checklist_response)
      {:error, %Ecto.Changeset{}}

  """
  def delete_checklist_response(%Scope{} = scope, %ChecklistResponse{} = checklist_response) do
    true = checklist_response.user_id == scope.user.id

    with {:ok, checklist_response = %ChecklistResponse{}} <-
           Repo.delete(checklist_response) do
      broadcast_checklist_response(scope, {:deleted, checklist_response})
      {:ok, checklist_response}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking checklist_response changes.

  ## Examples

      iex> change_checklist_response(scope, checklist_response, %{})
      %Ecto.Changeset{data: %ChecklistResponse{}}

  """
  def change_checklist_response(%Scope{} = scope, %ChecklistResponse{} = checklist_response, attrs) do
    true = checklist_response.user_id == scope.user.id

    ChecklistResponse.changeset(checklist_response, attrs, scope)
  end
end
