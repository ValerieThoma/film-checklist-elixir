defmodule FilmChecklistWeb.FilmLive.Form do
  use FilmChecklistWeb, :live_view

  alias FilmChecklist.Films
  alias FilmChecklist.Films.Film

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage film records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="film-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:year]} type="number" label="Year" />
        <.input field={@form[:poster_url]} type="text" label="Poster url" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Film</.button>
          <.button navigate={return_path(@current_scope, @return_to, @film)}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    film = Films.get_film!(socket.assigns.current_scope, id)

    socket
    |> assign(:page_title, "Edit Film")
    |> assign(:film, film)
    |> assign(:form, to_form(Films.change_film(socket.assigns.current_scope, film, %{})))
  end

  defp apply_action(socket, :new, _params) do
    film = %Film{}

    socket
    |> assign(:page_title, "New Film")
    |> assign(:film, film)
    |> assign(:form, to_form(Films.change_film(socket.assigns.current_scope, film, %{})))
  end

  @impl true
  def handle_event("validate", %{"film" => film_params}, socket) do
    changeset = Films.change_film(socket.assigns.current_scope, socket.assigns.film, film_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"film" => film_params}, socket) do
    save_film(socket, socket.assigns.live_action, film_params)
  end

  defp save_film(socket, :edit, film_params) do
    case Films.update_film(socket.assigns.current_scope, socket.assigns.film, film_params) do
      {:ok, film} ->
        {:noreply,
         socket
         |> put_flash(:info, "Film updated successfully")
         |> push_navigate(
           to: return_path(socket.assigns.current_scope, socket.assigns.return_to, film)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_film(socket, :new, film_params) do
    case Films.create_film(socket.assigns.current_scope, film_params) do
      {:ok, film} ->
        {:noreply,
         socket
         |> put_flash(:info, "Film created successfully")
         |> push_navigate(
           to: return_path(socket.assigns.current_scope, socket.assigns.return_to, film)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path(_scope, "index", _film), do: ~p"/films"
  defp return_path(_scope, "show", film), do: ~p"/films/#{film}"
end
