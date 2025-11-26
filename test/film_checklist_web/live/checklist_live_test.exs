defmodule FilmChecklistWeb.ChecklistLiveTest do
  use FilmChecklistWeb.ConnCase

  import Phoenix.LiveViewTest
  import FilmChecklist.ChecklistsFixtures

  @create_attrs %{completed: true, total_score: 42}
  @update_attrs %{completed: false, total_score: 43}
  @invalid_attrs %{completed: false, total_score: nil}

  setup :register_and_log_in_user

  defp create_checklist(%{scope: scope}) do
    checklist = checklist_fixture(scope)

    %{checklist: checklist}
  end

  describe "Index" do
    setup [:create_checklist]

    test "lists all checklists", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/checklists")

      assert html =~ "Listing Checklists"
    end

    test "saves new checklist", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/checklists")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Checklist")
               |> render_click()
               |> follow_redirect(conn, ~p"/checklists/new")

      assert render(form_live) =~ "New Checklist"

      assert form_live
             |> form("#checklist-form", checklist: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#checklist-form", checklist: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/checklists")

      html = render(index_live)
      assert html =~ "Checklist created successfully"
    end

    test "updates checklist in listing", %{conn: conn, checklist: checklist} do
      {:ok, index_live, _html} = live(conn, ~p"/checklists")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#checklists-#{checklist.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/checklists/#{checklist}/edit")

      assert render(form_live) =~ "Edit Checklist"

      assert form_live
             |> form("#checklist-form", checklist: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#checklist-form", checklist: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/checklists")

      html = render(index_live)
      assert html =~ "Checklist updated successfully"
    end

    test "deletes checklist in listing", %{conn: conn, checklist: checklist} do
      {:ok, index_live, _html} = live(conn, ~p"/checklists")

      assert index_live |> element("#checklists-#{checklist.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#checklists-#{checklist.id}")
    end
  end

  describe "Show" do
    setup [:create_checklist]

    test "displays checklist", %{conn: conn, checklist: checklist} do
      {:ok, _show_live, html} = live(conn, ~p"/checklists/#{checklist}")

      assert html =~ "Show Checklist"
    end

    test "updates checklist and returns to show", %{conn: conn, checklist: checklist} do
      {:ok, show_live, _html} = live(conn, ~p"/checklists/#{checklist}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/checklists/#{checklist}/edit?return_to=show")

      assert render(form_live) =~ "Edit Checklist"

      assert form_live
             |> form("#checklist-form", checklist: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#checklist-form", checklist: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/checklists/#{checklist}")

      html = render(show_live)
      assert html =~ "Checklist updated successfully"
    end
  end
end
