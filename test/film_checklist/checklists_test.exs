defmodule FilmChecklist.ChecklistsTest do
  use FilmChecklist.DataCase

  alias FilmChecklist.Checklists

  describe "checklists" do
    alias FilmChecklist.Checklists.Checklist

    import FilmChecklist.ChecklistsFixtures

    @invalid_attrs %{completed: nil, total_score: nil}

    test "list_checklists/0 returns all checklists" do
      checklist = checklist_fixture()
      assert Checklists.list_checklists() == [checklist]
    end

    test "get_checklist!/1 returns the checklist with given id" do
      checklist = checklist_fixture()
      assert Checklists.get_checklist!(checklist.id) == checklist
    end

    test "create_checklist/1 with valid data creates a checklist" do
      valid_attrs = %{completed: true, total_score: 42}

      assert {:ok, %Checklist{} = checklist} = Checklists.create_checklist(valid_attrs)
      assert checklist.completed == true
      assert checklist.total_score == 42
    end

    test "create_checklist/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Checklists.create_checklist(@invalid_attrs)
    end

    test "update_checklist/2 with valid data updates the checklist" do
      checklist = checklist_fixture()
      update_attrs = %{completed: false, total_score: 43}

      assert {:ok, %Checklist{} = checklist} = Checklists.update_checklist(checklist, update_attrs)
      assert checklist.completed == false
      assert checklist.total_score == 43
    end

    test "update_checklist/2 with invalid data returns error changeset" do
      checklist = checklist_fixture()
      assert {:error, %Ecto.Changeset{}} = Checklists.update_checklist(checklist, @invalid_attrs)
      assert checklist == Checklists.get_checklist!(checklist.id)
    end

    test "delete_checklist/1 deletes the checklist" do
      checklist = checklist_fixture()
      assert {:ok, %Checklist{}} = Checklists.delete_checklist(checklist)
      assert_raise Ecto.NoResultsError, fn -> Checklists.get_checklist!(checklist.id) end
    end

    test "change_checklist/1 returns a checklist changeset" do
      checklist = checklist_fixture()
      assert %Ecto.Changeset{} = Checklists.change_checklist(checklist)
    end
  end

  describe "checklist_items" do
    alias FilmChecklist.Checklists.ChecklistItem

    import FilmChecklist.ChecklistsFixtures

    @invalid_attrs %{name: nil, section: nil, point_value: nil, order_position: nil, response_type: nil}

    test "list_checklist_items/0 returns all checklist_items" do
      checklist_item = checklist_item_fixture()
      assert Checklists.list_checklist_items() == [checklist_item]
    end

    test "get_checklist_item!/1 returns the checklist_item with given id" do
      checklist_item = checklist_item_fixture()
      assert Checklists.get_checklist_item!(checklist_item.id) == checklist_item
    end

    test "create_checklist_item/1 with valid data creates a checklist_item" do
      valid_attrs = %{name: "some name", section: "some section", point_value: 42, order_position: 42, response_type: "some response_type"}

      assert {:ok, %ChecklistItem{} = checklist_item} = Checklists.create_checklist_item(valid_attrs)
      assert checklist_item.name == "some name"
      assert checklist_item.section == "some section"
      assert checklist_item.point_value == 42
      assert checklist_item.order_position == 42
      assert checklist_item.response_type == "some response_type"
    end

    test "create_checklist_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Checklists.create_checklist_item(@invalid_attrs)
    end

    test "update_checklist_item/2 with valid data updates the checklist_item" do
      checklist_item = checklist_item_fixture()
      update_attrs = %{name: "some updated name", section: "some updated section", point_value: 43, order_position: 43, response_type: "some updated response_type"}

      assert {:ok, %ChecklistItem{} = checklist_item} = Checklists.update_checklist_item(checklist_item, update_attrs)
      assert checklist_item.name == "some updated name"
      assert checklist_item.section == "some updated section"
      assert checklist_item.point_value == 43
      assert checklist_item.order_position == 43
      assert checklist_item.response_type == "some updated response_type"
    end

    test "update_checklist_item/2 with invalid data returns error changeset" do
      checklist_item = checklist_item_fixture()
      assert {:error, %Ecto.Changeset{}} = Checklists.update_checklist_item(checklist_item, @invalid_attrs)
      assert checklist_item == Checklists.get_checklist_item!(checklist_item.id)
    end

    test "delete_checklist_item/1 deletes the checklist_item" do
      checklist_item = checklist_item_fixture()
      assert {:ok, %ChecklistItem{}} = Checklists.delete_checklist_item(checklist_item)
      assert_raise Ecto.NoResultsError, fn -> Checklists.get_checklist_item!(checklist_item.id) end
    end

    test "change_checklist_item/1 returns a checklist_item changeset" do
      checklist_item = checklist_item_fixture()
      assert %Ecto.Changeset{} = Checklists.change_checklist_item(checklist_item)
    end
  end

  describe "checklist_responses" do
    alias FilmChecklist.Checklists.ChecklistResponse

    import FilmChecklist.ChecklistsFixtures

    @invalid_attrs %{value: nil}

    test "list_checklist_responses/0 returns all checklist_responses" do
      checklist_response = checklist_response_fixture()
      assert Checklists.list_checklist_responses() == [checklist_response]
    end

    test "get_checklist_response!/1 returns the checklist_response with given id" do
      checklist_response = checklist_response_fixture()
      assert Checklists.get_checklist_response!(checklist_response.id) == checklist_response
    end

    test "create_checklist_response/1 with valid data creates a checklist_response" do
      valid_attrs = %{value: "some value"}

      assert {:ok, %ChecklistResponse{} = checklist_response} = Checklists.create_checklist_response(valid_attrs)
      assert checklist_response.value == "some value"
    end

    test "create_checklist_response/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Checklists.create_checklist_response(@invalid_attrs)
    end

    test "update_checklist_response/2 with valid data updates the checklist_response" do
      checklist_response = checklist_response_fixture()
      update_attrs = %{value: "some updated value"}

      assert {:ok, %ChecklistResponse{} = checklist_response} = Checklists.update_checklist_response(checklist_response, update_attrs)
      assert checklist_response.value == "some updated value"
    end

    test "update_checklist_response/2 with invalid data returns error changeset" do
      checklist_response = checklist_response_fixture()
      assert {:error, %Ecto.Changeset{}} = Checklists.update_checklist_response(checklist_response, @invalid_attrs)
      assert checklist_response == Checklists.get_checklist_response!(checklist_response.id)
    end

    test "delete_checklist_response/1 deletes the checklist_response" do
      checklist_response = checklist_response_fixture()
      assert {:ok, %ChecklistResponse{}} = Checklists.delete_checklist_response(checklist_response)
      assert_raise Ecto.NoResultsError, fn -> Checklists.get_checklist_response!(checklist_response.id) end
    end

    test "change_checklist_response/1 returns a checklist_response changeset" do
      checklist_response = checklist_response_fixture()
      assert %Ecto.Changeset{} = Checklists.change_checklist_response(checklist_response)
    end
  end

  describe "checklists" do
    alias FilmChecklist.Checklists.Checklist

    import FilmChecklist.AccountsFixtures, only: [user_scope_fixture: 0]
    import FilmChecklist.ChecklistsFixtures

    @invalid_attrs %{completed: nil, total_score: nil}

    test "list_checklists/1 returns all scoped checklists" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      checklist = checklist_fixture(scope)
      other_checklist = checklist_fixture(other_scope)
      assert Checklists.list_checklists(scope) == [checklist]
      assert Checklists.list_checklists(other_scope) == [other_checklist]
    end

    test "get_checklist!/2 returns the checklist with given id" do
      scope = user_scope_fixture()
      checklist = checklist_fixture(scope)
      other_scope = user_scope_fixture()
      assert Checklists.get_checklist!(scope, checklist.id) == checklist
      assert_raise Ecto.NoResultsError, fn -> Checklists.get_checklist!(other_scope, checklist.id) end
    end

    test "create_checklist/2 with valid data creates a checklist" do
      valid_attrs = %{completed: true, total_score: 42}
      scope = user_scope_fixture()

      assert {:ok, %Checklist{} = checklist} = Checklists.create_checklist(scope, valid_attrs)
      assert checklist.completed == true
      assert checklist.total_score == 42
      assert checklist.user_id == scope.user.id
    end

    test "create_checklist/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Checklists.create_checklist(scope, @invalid_attrs)
    end

    test "update_checklist/3 with valid data updates the checklist" do
      scope = user_scope_fixture()
      checklist = checklist_fixture(scope)
      update_attrs = %{completed: false, total_score: 43}

      assert {:ok, %Checklist{} = checklist} = Checklists.update_checklist(scope, checklist, update_attrs)
      assert checklist.completed == false
      assert checklist.total_score == 43
    end

    test "update_checklist/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      checklist = checklist_fixture(scope)

      assert_raise MatchError, fn ->
        Checklists.update_checklist(other_scope, checklist, %{})
      end
    end

    test "update_checklist/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      checklist = checklist_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Checklists.update_checklist(scope, checklist, @invalid_attrs)
      assert checklist == Checklists.get_checklist!(scope, checklist.id)
    end

    test "delete_checklist/2 deletes the checklist" do
      scope = user_scope_fixture()
      checklist = checklist_fixture(scope)
      assert {:ok, %Checklist{}} = Checklists.delete_checklist(scope, checklist)
      assert_raise Ecto.NoResultsError, fn -> Checklists.get_checklist!(scope, checklist.id) end
    end

    test "delete_checklist/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      checklist = checklist_fixture(scope)
      assert_raise MatchError, fn -> Checklists.delete_checklist(other_scope, checklist) end
    end

    test "change_checklist/2 returns a checklist changeset" do
      scope = user_scope_fixture()
      checklist = checklist_fixture(scope)
      assert %Ecto.Changeset{} = Checklists.change_checklist(scope, checklist)
    end
  end

  describe "checklist_items" do
    alias FilmChecklist.Checklists.ChecklistItem

    import FilmChecklist.AccountsFixtures, only: [user_scope_fixture: 0]
    import FilmChecklist.ChecklistsFixtures

    @invalid_attrs %{name: nil, section: nil, point_value: nil, order_position: nil, response_type: nil}

    test "list_checklist_items/1 returns all scoped checklist_items" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      checklist_item = checklist_item_fixture(scope)
      other_checklist_item = checklist_item_fixture(other_scope)
      assert Checklists.list_checklist_items(scope) == [checklist_item]
      assert Checklists.list_checklist_items(other_scope) == [other_checklist_item]
    end

    test "get_checklist_item!/2 returns the checklist_item with given id" do
      scope = user_scope_fixture()
      checklist_item = checklist_item_fixture(scope)
      other_scope = user_scope_fixture()
      assert Checklists.get_checklist_item!(scope, checklist_item.id) == checklist_item
      assert_raise Ecto.NoResultsError, fn -> Checklists.get_checklist_item!(other_scope, checklist_item.id) end
    end

    test "create_checklist_item/2 with valid data creates a checklist_item" do
      valid_attrs = %{name: "some name", section: "some section", point_value: 42, order_position: 42, response_type: "some response_type"}
      scope = user_scope_fixture()

      assert {:ok, %ChecklistItem{} = checklist_item} = Checklists.create_checklist_item(scope, valid_attrs)
      assert checklist_item.name == "some name"
      assert checklist_item.section == "some section"
      assert checklist_item.point_value == 42
      assert checklist_item.order_position == 42
      assert checklist_item.response_type == "some response_type"
      assert checklist_item.user_id == scope.user.id
    end

    test "create_checklist_item/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Checklists.create_checklist_item(scope, @invalid_attrs)
    end

    test "update_checklist_item/3 with valid data updates the checklist_item" do
      scope = user_scope_fixture()
      checklist_item = checklist_item_fixture(scope)
      update_attrs = %{name: "some updated name", section: "some updated section", point_value: 43, order_position: 43, response_type: "some updated response_type"}

      assert {:ok, %ChecklistItem{} = checklist_item} = Checklists.update_checklist_item(scope, checklist_item, update_attrs)
      assert checklist_item.name == "some updated name"
      assert checklist_item.section == "some updated section"
      assert checklist_item.point_value == 43
      assert checklist_item.order_position == 43
      assert checklist_item.response_type == "some updated response_type"
    end

    test "update_checklist_item/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      checklist_item = checklist_item_fixture(scope)

      assert_raise MatchError, fn ->
        Checklists.update_checklist_item(other_scope, checklist_item, %{})
      end
    end

    test "update_checklist_item/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      checklist_item = checklist_item_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Checklists.update_checklist_item(scope, checklist_item, @invalid_attrs)
      assert checklist_item == Checklists.get_checklist_item!(scope, checklist_item.id)
    end

    test "delete_checklist_item/2 deletes the checklist_item" do
      scope = user_scope_fixture()
      checklist_item = checklist_item_fixture(scope)
      assert {:ok, %ChecklistItem{}} = Checklists.delete_checklist_item(scope, checklist_item)
      assert_raise Ecto.NoResultsError, fn -> Checklists.get_checklist_item!(scope, checklist_item.id) end
    end

    test "delete_checklist_item/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      checklist_item = checklist_item_fixture(scope)
      assert_raise MatchError, fn -> Checklists.delete_checklist_item(other_scope, checklist_item) end
    end

    test "change_checklist_item/2 returns a checklist_item changeset" do
      scope = user_scope_fixture()
      checklist_item = checklist_item_fixture(scope)
      assert %Ecto.Changeset{} = Checklists.change_checklist_item(scope, checklist_item)
    end
  end

  describe "checklist_responses" do
    alias FilmChecklist.Checklists.ChecklistResponse

    import FilmChecklist.AccountsFixtures, only: [user_scope_fixture: 0]
    import FilmChecklist.ChecklistsFixtures

    @invalid_attrs %{value: nil}

    test "list_checklist_responses/1 returns all scoped checklist_responses" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      checklist_response = checklist_response_fixture(scope)
      other_checklist_response = checklist_response_fixture(other_scope)
      assert Checklists.list_checklist_responses(scope) == [checklist_response]
      assert Checklists.list_checklist_responses(other_scope) == [other_checklist_response]
    end

    test "get_checklist_response!/2 returns the checklist_response with given id" do
      scope = user_scope_fixture()
      checklist_response = checklist_response_fixture(scope)
      other_scope = user_scope_fixture()
      assert Checklists.get_checklist_response!(scope, checklist_response.id) == checklist_response
      assert_raise Ecto.NoResultsError, fn -> Checklists.get_checklist_response!(other_scope, checklist_response.id) end
    end

    test "create_checklist_response/2 with valid data creates a checklist_response" do
      valid_attrs = %{value: "some value"}
      scope = user_scope_fixture()

      assert {:ok, %ChecklistResponse{} = checklist_response} = Checklists.create_checklist_response(scope, valid_attrs)
      assert checklist_response.value == "some value"
      assert checklist_response.user_id == scope.user.id
    end

    test "create_checklist_response/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Checklists.create_checklist_response(scope, @invalid_attrs)
    end

    test "update_checklist_response/3 with valid data updates the checklist_response" do
      scope = user_scope_fixture()
      checklist_response = checklist_response_fixture(scope)
      update_attrs = %{value: "some updated value"}

      assert {:ok, %ChecklistResponse{} = checklist_response} = Checklists.update_checklist_response(scope, checklist_response, update_attrs)
      assert checklist_response.value == "some updated value"
    end

    test "update_checklist_response/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      checklist_response = checklist_response_fixture(scope)

      assert_raise MatchError, fn ->
        Checklists.update_checklist_response(other_scope, checklist_response, %{})
      end
    end

    test "update_checklist_response/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      checklist_response = checklist_response_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Checklists.update_checklist_response(scope, checklist_response, @invalid_attrs)
      assert checklist_response == Checklists.get_checklist_response!(scope, checklist_response.id)
    end

    test "delete_checklist_response/2 deletes the checklist_response" do
      scope = user_scope_fixture()
      checklist_response = checklist_response_fixture(scope)
      assert {:ok, %ChecklistResponse{}} = Checklists.delete_checklist_response(scope, checklist_response)
      assert_raise Ecto.NoResultsError, fn -> Checklists.get_checklist_response!(scope, checklist_response.id) end
    end

    test "delete_checklist_response/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      checklist_response = checklist_response_fixture(scope)
      assert_raise MatchError, fn -> Checklists.delete_checklist_response(other_scope, checklist_response) end
    end

    test "change_checklist_response/2 returns a checklist_response changeset" do
      scope = user_scope_fixture()
      checklist_response = checklist_response_fixture(scope)
      assert %Ecto.Changeset{} = Checklists.change_checklist_response(scope, checklist_response)
    end
  end
end
