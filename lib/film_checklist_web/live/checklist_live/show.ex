defmodule FilmChecklistWeb.ChecklistLive.Show do
  use FilmChecklistWeb, :live_view

  alias FilmChecklist.Checklists
  alias FilmChecklist.Films
  alias FilmChecklist.Repo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    checklist = Checklists.get_checklist!(id)
    
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:checklist, checklist)
     |> assign(:film, checklist.film)}
  end

  defp page_title(:show), do: "Show Checklist"
  defp page_title(:edit), do: "Edit Checklist"
end