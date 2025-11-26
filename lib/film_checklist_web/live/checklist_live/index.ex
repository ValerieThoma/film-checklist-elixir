defmodule FilmChecklistWeb.ChecklistLive.Index do
  use FilmChecklistWeb, :live_view

  alias FilmChecklist.Checklists
  alias FilmChecklist.Films
  alias FilmChecklist.Checklists.Checklist

  @impl true
  def mount(_params, _session, socket) do
    # Access user through current_scope
    current_user = socket.assigns.current_scope.user
    checklists = list_checklists(current_user)
    
    {:ok, 
     socket
     |> assign(:checklists, checklists)
     |> stream(:checklists, checklists)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Your Checklists")
    |> assign(:checklist, nil)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Checklist")
    |> assign(:checklist, %Checklist{})
  end

  defp list_checklists(user) do
    Checklists.list_user_checklists(user.id)
  end
end