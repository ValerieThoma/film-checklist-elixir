defmodule FilmChecklistWeb.FilmLive.Index do
  use FilmChecklistWeb, :live_view

  alias FilmChecklist.Films

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Listing Films
        <:actions>
          <.button variant="primary" navigate={~p"/films/new"}>
            <.icon name="hero-plus" /> New Film
          </.button>
        </:actions>
      </.header>

      <.table
        id="films"
        rows={@streams.films}
        row_click={fn {_id, film} -> JS.navigate(~p"/films/#{film}") end}
      >
        <:col :let={{_id, film}} label="Title">{film.title}</:col>
        <:col :let={{_id, film}} label="Year">{film.year}</:col>
        <:col :let={{_id, film}} label="Poster url">{film.poster_url}</:col>
        <:action :let={{_id, film}}>
          <div class="sr-only">
            <.link navigate={~p"/films/#{film}"}>Show</.link>
          </div>
          <.link navigate={~p"/films/#{film}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, film}}>
          <.link
            phx-click={JS.push("delete", value: %{id: film.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Films.subscribe_films(socket.assigns.current_scope)
    end

    {:ok,
     socket
     |> assign(:page_title, "Listing Films")
     |> stream(:films, list_films(socket.assigns.current_scope))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    film = Films.get_film!(socket.assigns.current_scope, id)
    {:ok, _} = Films.delete_film(socket.assigns.current_scope, film)

    {:noreply, stream_delete(socket, :films, film)}
  end

  @impl true
  def handle_info({type, %FilmChecklist.Films.Film{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, stream(socket, :films, list_films(socket.assigns.current_scope), reset: true)}
  end

  defp list_films(current_scope) do
    Films.list_films(current_scope)
  end
end
