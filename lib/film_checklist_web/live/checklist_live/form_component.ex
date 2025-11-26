defmodule FilmChecklistWeb.ChecklistLive.FormComponent do
  use FilmChecklistWeb, :live_component
  
  alias FilmChecklist.Checklists
  alias FilmChecklist.Repo
  
  @impl true
  def render(assigns) do
    ~H"""
    <div class="checklist-container">
      <.header>
        <%= @film.title %> <%= if @film.year, do: "(#{@film.year})" %>
        <:subtitle>
          Score: <%= Decimal.round(@current_score, 2) %> / <%= Decimal.round(@max_score, 2) %> tampons
          <%= if Decimal.compare(@current_score, Decimal.new("3")) != :lt do %>
            <span class="text-green-600 font-bold">✓ CHICK FLICK!</span>
          <% end %>
        </:subtitle>
      </.header>
      
      <div class="checklist-sections space-y-8">
        <%!-- Section 1: Main tropes --%>
        <div class="section">
          <h3 class="text-lg font-semibold mb-4">
            1. Which of the following elements/devices are found in this movie? Check all that apply:
          </h3>
          <%= for item <- @tropes_items do %>
            <div class="checklist-item mb-2">
              <label class="flex items-start space-x-2 cursor-pointer">
                <input
                  type="checkbox"
                  phx-click="toggle_item"
                  phx-value-item-id={item.id}
                  phx-target={@myself}
                  checked={response_value(@responses, item.id) == "true"}
                  class="mt-1"
                />
                <span class="text-sm"><%= item.name %></span>
              </label>
            </div>
          <% end %>
        </div>

        <%!-- Section 2: Actors --%>
        <div class="section">
          <h3 class="text-lg font-semibold mb-4">
            2. Which of the following performers are featured in this movie? Check all that apply:
          </h3>
          <div class="grid grid-cols-2 gap-2">
            <%= for item <- @actors_items do %>
              <div class="checklist-item">
                <label class="flex items-center space-x-2 cursor-pointer">
                  <input
                    type="checkbox"
                    phx-click="toggle_item"
                    phx-value-item-id={item.id}
                    phx-target={@myself}
                    checked={response_value(@responses, item.id) == "true"}
                  />
                  <span class="text-sm"><%= item.name %></span>
                </label>
              </div>
            <% end %>
          </div>
        </div>

        <%!-- Section 3: Special Authors --%>
        <div class="section">
          <h3 class="text-lg font-semibold mb-4">
            3. Was this movie adapted from a novel written by Jane Austen, Terry McMillan, or Nicholas Sparks?
          </h3>
          <%= for item <- @special_authors_items do %>
            <div class="space-y-2">
              <label class="flex items-center space-x-2 cursor-pointer">
                <input
                  type="radio"
                  name={"question-#{item.id}"}
                  value="Yes"
                  phx-click="set_radio"
                  phx-value-item-id={item.id}
                  phx-value-value="Yes"
                  phx-target={@myself}
                  checked={response_value(@responses, item.id) == "Yes"}
                />
                <span>Yes (1 tampon)</span>
              </label>
              <label class="flex items-center space-x-2 cursor-pointer">
                <input
                  type="radio"
                  name={"question-#{item.id}"}
                  value="No"
                  phx-click="set_radio"
                  phx-value-item-id={item.id}
                  phx-value-value="No"
                  phx-target={@myself}
                  checked={response_value(@responses, item.id) == "No"}
                />
                <span>No</span>
              </label>
            </div>
          <% end %>
        </div>

        <%!-- Section 4: Reverse Bechdel --%>
        <div class="section">
          <h3 class="text-lg font-semibold mb-4">
            4. Does this movie pass the reverse Bechdel test (i.e., does it feature two or more named male characters who talk to each other about something other than a woman)?
          </h3>
          <%= for item <- @reverse_bechdel_items do %>
            <div class="space-y-2">
              <label class="flex items-center space-x-2 cursor-pointer">
                <input
                  type="radio"
                  name={"question-#{item.id}"}
                  value="Yes"
                  phx-click="set_radio"
                  phx-value-item-id={item.id}
                  phx-value-value="Yes"
                  phx-target={@myself}
                  checked={response_value(@responses, item.id) == "Yes"}
                />
                <span>Yes</span>
              </label>
              <label class="flex items-center space-x-2 cursor-pointer">
                <input
                  type="radio"
                  name={"question-#{item.id}"}
                  value="No"
                  phx-click="set_radio"
                  phx-value-item-id={item.id}
                  phx-value-value="No"
                  phx-target={@myself}
                  checked={response_value(@responses, item.id) == "No"}
                />
                <span>No (1 tampon)</span>
              </label>
              <label class="flex items-center space-x-2 cursor-pointer">
                <input
                  type="radio"
                  name={"question-#{item.id}"}
                  value="Kind of"
                  phx-click="set_radio"
                  phx-value-item-id={item.id}
                  phx-value-value="Kind of"
                  phx-target={@myself}
                  checked={response_value(@responses, item.id) == "Kind of"}
                />
                <span>Kind of? (0.5 tampons)</span>
              </label>
            </div>
          <% end %>
        </div>
      </div>
      
      <div class="mt-8 p-4 bg-gray-100 rounded text-center">
        <h2 class="text-xl font-bold mb-2">Tally your tampons!</h2>
        <p class="text-lg">
          <%= if Decimal.compare(@current_score, Decimal.new("3")) != :lt do %>
            <span class="text-green-600 font-bold">
              If you figured 3 or more full tampons, this movie is a chick flick! ✓
            </span>
          <% else %>
            <span>Fewer than 3 -- not so much for you, ladies.</span>
          <% end %>
        </p>
      </div>
      
      <div class="mt-4 flex gap-2">
        <.button phx-click="save_checklist" phx-target={@myself}>
          Save Checklist
        </.button>
      </div>
    </div>
    """
  end
  
  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> load_checklist_data()}
  end
  
  defp load_checklist_data(socket) do
    items = Checklists.list_checklist_items()
    
    # Group items by section
    tropes_items = Enum.filter(items, & &1.section == "tropes")
    actors_items = Enum.filter(items, & &1.section == "actors")
    special_authors_items = Enum.filter(items, & &1.section == "special_authors")
    reverse_bechdel_items = Enum.filter(items, & &1.section == "reverse_bechdel")
    
    responses = load_or_create_responses(socket.assigns.checklist, items)
    
    current_score = calculate_score(items, responses)
    max_score = calculate_max_score(items)
    
    socket
    |> assign(:tropes_items, tropes_items)
    |> assign(:actors_items, actors_items)
    |> assign(:special_authors_items, special_authors_items)
    |> assign(:reverse_bechdel_items, reverse_bechdel_items)
    |> assign(:responses, responses)
    |> assign(:current_score, current_score)
    |> assign(:max_score, max_score)
  end
  
  @impl true
  def handle_event("toggle_item", %{"item-id" => item_id}, socket) do
    item_id = String.to_integer(item_id)
    response = Enum.find(socket.assigns.responses, & &1.checklist_item_id == item_id)
    
    new_value = if response.value == "true", do: "false", else: "true"
    
    {:ok, updated_response} = 
      Checklists.update_checklist_response(response, %{value: new_value})
    
    {:noreply, update_response_and_score(socket, updated_response)}
  end
  
  @impl true
  def handle_event("set_radio", %{"item-id" => item_id, "value" => value}, socket) do
    item_id = String.to_integer(item_id)
    response = Enum.find(socket.assigns.responses, & &1.checklist_item_id == item_id)
    
    {:ok, updated_response} = 
      Checklists.update_checklist_response(response, %{value: value})
    
    {:noreply, update_response_and_score(socket, updated_response)}
  end
  
  @impl true
  def handle_event("save_checklist", _, socket) do
    # Update the checklist with the final score
    {:ok, _checklist} = 
      Checklists.update_checklist(socket.assigns.checklist, %{
        total_score: socket.assigns.current_score,
        completed: true
      })
    
    {:noreply,
     socket
     |> put_flash(:info, "Checklist saved successfully!")
     |> push_navigate(to: ~p"/checklists")}
  end
  
  defp load_or_create_responses(checklist, items) do
    existing_responses = Checklists.list_checklist_responses(checklist.id)
    
    Enum.map(items, fn item ->
      case Enum.find(existing_responses, & &1.checklist_item_id == item.id) do
        nil ->
          default_value = if item.response_type == "radio", do: "No", else: "false"
          {:ok, response} = 
            Checklists.create_checklist_response(%{
              checklist_id: checklist.id,
              checklist_item_id: item.id,
              value: default_value
            })
          response
        response ->
          response
      end
    end)
  end
  
  defp update_response_and_score(socket, updated_response) do
    responses = 
      Enum.map(socket.assigns.responses, fn r ->
        if r.id == updated_response.id, do: updated_response, else: r
      end)
    
    all_items = socket.assigns.tropes_items ++ socket.assigns.actors_items ++ 
                socket.assigns.special_authors_items ++ socket.assigns.reverse_bechdel_items
    
    current_score = calculate_score(all_items, responses)
    
    socket
    |> assign(:responses, responses)
    |> assign(:current_score, current_score)
  end
  
  defp calculate_score(items, responses) do
    Enum.reduce(responses, Decimal.new("0"), fn response, acc ->
      item = Enum.find(items, & &1.id == response.checklist_item_id)
      
      case {item.section, response.value} do
        # Checkboxes that are checked
        {section, "true"} when section in ["tropes", "actors"] -> 
          Decimal.add(acc, item.point_value)
        
        # Special Authors question
        {"special_authors", "Yes"} -> 
          Decimal.add(acc, Decimal.new("1"))
          
        # Reverse Bechdel test  
        {"reverse_bechdel", "No"} -> 
          Decimal.add(acc, Decimal.new("1"))
        {"reverse_bechdel", "Kind of"} -> 
          Decimal.add(acc, Decimal.new("0.5"))
          
        _ -> acc
      end
    end)
  end
  
  defp calculate_max_score(items) do
    tropes_actors = Enum.filter(items, & &1.section in ["tropes", "actors"] && &1.point_value > 0)
    max_checkboxes = Enum.reduce(tropes_actors, Decimal.new("0"), fn item, acc ->
      Decimal.add(acc, item.point_value)
    end)
    
    # Add 1 for special authors + 1 for reverse bechdel
    Decimal.add(max_checkboxes, Decimal.new("2"))
  end
  
  defp response_value(responses, item_id) do
    case Enum.find(responses, & &1.checklist_item_id == item_id) do
      nil -> "false"
      response -> response.value
    end
  end
end