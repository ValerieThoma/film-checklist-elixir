defmodule FilmChecklistWeb.ChecklistLive.Form do
  use FilmChecklistWeb, :live_view

  alias FilmChecklist.Checklists
  alias FilmChecklist.Checklists.Checklist

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage checklist records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="checklist-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:completed]} type="checkbox" label="Completed" />
        <.input field={@form[:total_score]} type="number" label="Total score" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Checklist</.button>
          <.button navigate={return_path(@current_scope, @return_to, @checklist)}>Cancel</.button>
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
    checklist = Checklists.get_checklist!(socket.assigns.current_scope, id)

    socket
    |> assign(:page_title, "Edit Checklist")
    |> assign(:checklist, checklist)
    |> assign(:form, to_form(Checklists.change_checklist(socket.assigns.current_scope, checklist, %{})))
  end

  defp apply_action(socket, :new, _params) do
    checklist = %Checklist{}

    socket
    |> assign(:page_title, "New Checklist")
    |> assign(:checklist, checklist)
    |> assign(:form, to_form(Checklists.change_checklist(socket.assigns.current_scope, checklist, %{})))
  end

  @impl true
  def handle_event("validate", %{"checklist" => checklist_params}, socket) do
    changeset = Checklists.change_checklist(socket.assigns.current_scope, socket.assigns.checklist, checklist_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"checklist" => checklist_params}, socket) do
    save_checklist(socket, socket.assigns.live_action, checklist_params)
  end

  defp save_checklist(socket, :edit, checklist_params) do
    case Checklists.update_checklist(socket.assigns.current_scope, socket.assigns.checklist, checklist_params) do
      {:ok, checklist} ->
        {:noreply,
         socket
         |> put_flash(:info, "Checklist updated successfully")
         |> push_navigate(
           to: return_path(socket.assigns.current_scope, socket.assigns.return_to, checklist)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_checklist(socket, :new, checklist_params) do
    case Checklists.create_checklist(socket.assigns.current_scope, checklist_params) do
      {:ok, checklist} ->
        {:noreply,
         socket
         |> put_flash(:info, "Checklist created successfully")
         |> push_navigate(
           to: return_path(socket.assigns.current_scope, socket.assigns.return_to, checklist)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path(_scope, "index", _checklist), do: ~p"/checklists"
  defp return_path(_scope, "show", checklist), do: ~p"/checklists/#{checklist}"
end
