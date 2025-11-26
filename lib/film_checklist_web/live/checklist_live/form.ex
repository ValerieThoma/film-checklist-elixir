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

      <.form for={@form} id="checklist-form" phx-submit="submit">
        <div class="space-y-6">
          <div class="space-y-4">
            <div class="text-sm font-semibold text-zinc-400 uppercase tracking-wide">
              Tropes
            </div>

            <div class="rounded-xl border border-zinc-800 bg-zinc-950/60 divide-y divide-zinc-800">
              <div
                :for={item <- @checklist_items}
                class="flex items-start justify-between gap-4 px-4 py-3"
              >
                <label class="flex items-start gap-3 w-full cursor-pointer">
                  <input
                    type="checkbox"
                    name={"checklist[responses][#{item.id}]"}
                    value={item.point_value}
                    class="mt-1 h-5 w-5 rounded border-zinc-500 text-brand focus:ring-brand"
                  />

                  <span class="flex-1 space-y-1">
                    <span class="block font-medium text-zinc-100">
                      {item.name}
                    </span>

                    <span class="block text-xs uppercase tracking-wide text-zinc-500">
                      {item.section}
                    </span>

                    <span class="block text-xs text-zinc-400">
                      +{item.point_value} points
                    </span>
                  </span>
                </label>
              </div>
            </div>
          </div>

          <div class="flex items-center justify-between rounded-xl bg-zinc-900/80 px-4 py-3">
            <div class="space-y-1">
              <div class="text-xs uppercase tracking-wide text-zinc-500">
                Total tampon score
              </div>
              <div class="text-sm text-zinc-400">
                Based on selected tropes above
              </div>
            </div>

            <div class="text-3xl font-semibold text-brand">
              {@total_score}
            </div>
          </div>

          <footer class="flex items-center justify-end gap-3 pt-2">
            <.button type="submit" name="action" value="tally">
              Tally score
            </.button>
            <.button type="submit" name="action" value="save" phx-disable-with="Saving..." variant="primary">
              Save Checklist
            </.button>
            <.button navigate={return_path(@current_scope, @return_to, @checklist)}>Cancel</.button>
          </footer>
        </div>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    items = Checklists.list_checklist_items()

    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> assign(:checklist_items, items)
     |> assign(:total_score, 0)
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    checklist = Checklists.get_checklist!(socket.assigns.current_scope, id)

    socket
    |> assign(:page_title, "Edit Checklist")
    |> assign(:checklist, checklist)
    |> assign(:total_score, checklist.total_score || 0)
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
  def handle_event("submit", %{"action" => "tally", "checklist" => checklist_params}, socket) do
    total_score = compute_total_score(checklist_params)

    {:noreply, assign(socket, :total_score, total_score)}
  end

  def handle_event("submit", %{"action" => "save", "checklist" => checklist_params}, socket) do
    save_checklist(socket, socket.assigns.live_action, checklist_params)
  end

  defp save_checklist(socket, :edit, checklist_params) do
    total_score = compute_total_score(checklist_params)
    checklist_params = Map.put(checklist_params, "total_score", total_score)

    case Checklists.update_checklist(
           socket.assigns.current_scope,
           socket.assigns.checklist,
           checklist_params
         ) do
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
    total_score = compute_total_score(checklist_params)
    checklist_params = Map.put(checklist_params, "total_score", total_score)

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

  defp compute_total_score(%{"responses" => responses}) when is_map(responses) do
    responses
    |> Map.values()
    |> Enum.reduce(0, fn value, acc ->
      case Integer.parse(to_string(value)) do
        {int, _} -> acc + int
        :error -> acc
      end
    end)
  end

  defp compute_total_score(_), do: 0

  defp return_path(_scope, "index", _checklist), do: ~p"/checklists"
  defp return_path(_scope, "show", checklist), do: ~p"/checklists/#{checklist}"
end
