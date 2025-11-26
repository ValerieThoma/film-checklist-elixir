defmodule FilmChecklistWeb.FilmLive.Show do
  use FilmChecklistWeb, :live_view

  alias FilmChecklist.Films

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Film {@film.id}
        <:subtitle>This is a film record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/films"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/films/#{@film}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit film
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Title">{@film.title}</:item>
        <:item title="Year">{@film.year}</:item>
        <:item title="Poster url">{@film.poster_url}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket) do
      Films.subscribe_films(socket.assigns.current_scope)
    end

    {:ok,
     socket
     |> assign(:page_title, "Show Film")
     |> assign(:film, Films.get_film!(socket.assigns.current_scope, id))}
  end

  @impl true
  def handle_info(
        {:updated, %FilmChecklist.Films.Film{id: id} = film},
        %{assigns: %{film: %{id: id}}} = socket
      ) do
    {:noreply, assign(socket, :film, film)}
  end

  def handle_info(
        {:deleted, %FilmChecklist.Films.Film{id: id}},
        %{assigns: %{film: %{id: id}}} = socket
      ) do
    {:noreply,
     socket
     |> put_flash(:error, "The current film was deleted.")
     |> push_navigate(to: ~p"/films")}
  end

  def handle_info({type, %FilmChecklist.Films.Film{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, socket}
  end
end
