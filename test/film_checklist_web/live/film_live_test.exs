defmodule FilmChecklistWeb.FilmLiveTest do
  use FilmChecklistWeb.ConnCase

  import Phoenix.LiveViewTest
  import FilmChecklist.FilmsFixtures

  @create_attrs %{title: "some title", year: 42, poster_url: "some poster_url"}
  @update_attrs %{title: "some updated title", year: 43, poster_url: "some updated poster_url"}
  @invalid_attrs %{title: nil, year: nil, poster_url: nil}

  setup :register_and_log_in_user

  defp create_film(%{scope: scope}) do
    film = film_fixture(scope)

    %{film: film}
  end

  describe "Index" do
    setup [:create_film]

    test "lists all films", %{conn: conn, film: film} do
      {:ok, _index_live, html} = live(conn, ~p"/films")

      assert html =~ "Listing Films"
      assert html =~ film.title
    end

    test "saves new film", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/films")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Film")
               |> render_click()
               |> follow_redirect(conn, ~p"/films/new")

      assert render(form_live) =~ "New Film"

      assert form_live
             |> form("#film-form", film: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#film-form", film: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/films")

      html = render(index_live)
      assert html =~ "Film created successfully"
      assert html =~ "some title"
    end

    test "updates film in listing", %{conn: conn, film: film} do
      {:ok, index_live, _html} = live(conn, ~p"/films")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#films-#{film.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/films/#{film}/edit")

      assert render(form_live) =~ "Edit Film"

      assert form_live
             |> form("#film-form", film: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#film-form", film: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/films")

      html = render(index_live)
      assert html =~ "Film updated successfully"
      assert html =~ "some updated title"
    end

    test "deletes film in listing", %{conn: conn, film: film} do
      {:ok, index_live, _html} = live(conn, ~p"/films")

      assert index_live |> element("#films-#{film.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#films-#{film.id}")
    end
  end

  describe "Show" do
    setup [:create_film]

    test "displays film", %{conn: conn, film: film} do
      {:ok, _show_live, html} = live(conn, ~p"/films/#{film}")

      assert html =~ "Show Film"
      assert html =~ film.title
    end

    test "updates film and returns to show", %{conn: conn, film: film} do
      {:ok, show_live, _html} = live(conn, ~p"/films/#{film}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/films/#{film}/edit?return_to=show")

      assert render(form_live) =~ "Edit Film"

      assert form_live
             |> form("#film-form", film: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#film-form", film: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/films/#{film}")

      html = render(show_live)
      assert html =~ "Film updated successfully"
      assert html =~ "some updated title"
    end
  end
end
