defmodule FilmChecklist.FilmsTest do
  use FilmChecklist.DataCase

  alias FilmChecklist.Films

  describe "films" do
    alias FilmChecklist.Films.Film

    import FilmChecklist.FilmsFixtures

    @invalid_attrs %{title: nil, year: nil, poster_url: nil}

    test "list_films/0 returns all films" do
      film = film_fixture()
      assert Films.list_films() == [film]
    end

    test "get_film!/1 returns the film with given id" do
      film = film_fixture()
      assert Films.get_film!(film.id) == film
    end

    test "create_film/1 with valid data creates a film" do
      valid_attrs = %{title: "some title", year: 42, poster_url: "some poster_url"}

      assert {:ok, %Film{} = film} = Films.create_film(valid_attrs)
      assert film.title == "some title"
      assert film.year == 42
      assert film.poster_url == "some poster_url"
    end

    test "create_film/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Films.create_film(@invalid_attrs)
    end

    test "update_film/2 with valid data updates the film" do
      film = film_fixture()
      update_attrs = %{title: "some updated title", year: 43, poster_url: "some updated poster_url"}

      assert {:ok, %Film{} = film} = Films.update_film(film, update_attrs)
      assert film.title == "some updated title"
      assert film.year == 43
      assert film.poster_url == "some updated poster_url"
    end

    test "update_film/2 with invalid data returns error changeset" do
      film = film_fixture()
      assert {:error, %Ecto.Changeset{}} = Films.update_film(film, @invalid_attrs)
      assert film == Films.get_film!(film.id)
    end

    test "delete_film/1 deletes the film" do
      film = film_fixture()
      assert {:ok, %Film{}} = Films.delete_film(film)
      assert_raise Ecto.NoResultsError, fn -> Films.get_film!(film.id) end
    end

    test "change_film/1 returns a film changeset" do
      film = film_fixture()
      assert %Ecto.Changeset{} = Films.change_film(film)
    end
  end

  describe "films" do
    alias FilmChecklist.Films.Film

    import FilmChecklist.AccountsFixtures, only: [user_scope_fixture: 0]
    import FilmChecklist.FilmsFixtures

    @invalid_attrs %{title: nil, year: nil, poster_url: nil}

    test "list_films/1 returns all scoped films" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      film = film_fixture(scope)
      other_film = film_fixture(other_scope)
      assert Films.list_films(scope) == [film]
      assert Films.list_films(other_scope) == [other_film]
    end

    test "get_film!/2 returns the film with given id" do
      scope = user_scope_fixture()
      film = film_fixture(scope)
      other_scope = user_scope_fixture()
      assert Films.get_film!(scope, film.id) == film
      assert_raise Ecto.NoResultsError, fn -> Films.get_film!(other_scope, film.id) end
    end

    test "create_film/2 with valid data creates a film" do
      valid_attrs = %{title: "some title", year: 42, poster_url: "some poster_url"}
      scope = user_scope_fixture()

      assert {:ok, %Film{} = film} = Films.create_film(scope, valid_attrs)
      assert film.title == "some title"
      assert film.year == 42
      assert film.poster_url == "some poster_url"
      assert film.user_id == scope.user.id
    end

    test "create_film/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Films.create_film(scope, @invalid_attrs)
    end

    test "update_film/3 with valid data updates the film" do
      scope = user_scope_fixture()
      film = film_fixture(scope)
      update_attrs = %{title: "some updated title", year: 43, poster_url: "some updated poster_url"}

      assert {:ok, %Film{} = film} = Films.update_film(scope, film, update_attrs)
      assert film.title == "some updated title"
      assert film.year == 43
      assert film.poster_url == "some updated poster_url"
    end

    test "update_film/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      film = film_fixture(scope)

      assert_raise MatchError, fn ->
        Films.update_film(other_scope, film, %{})
      end
    end

    test "update_film/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      film = film_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Films.update_film(scope, film, @invalid_attrs)
      assert film == Films.get_film!(scope, film.id)
    end

    test "delete_film/2 deletes the film" do
      scope = user_scope_fixture()
      film = film_fixture(scope)
      assert {:ok, %Film{}} = Films.delete_film(scope, film)
      assert_raise Ecto.NoResultsError, fn -> Films.get_film!(scope, film.id) end
    end

    test "delete_film/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      film = film_fixture(scope)
      assert_raise MatchError, fn -> Films.delete_film(other_scope, film) end
    end

    test "change_film/2 returns a film changeset" do
      scope = user_scope_fixture()
      film = film_fixture(scope)
      assert %Ecto.Changeset{} = Films.change_film(scope, film)
    end
  end
end
