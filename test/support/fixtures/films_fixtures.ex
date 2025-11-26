defmodule FilmChecklist.FilmsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `FilmChecklist.Films` context.
  """

  @doc """
  Generate a film.
  """
  def film_fixture(attrs \\ %{}) do
    {:ok, film} =
      attrs
      |> Enum.into(%{
        poster_url: "some poster_url",
        title: "some title",
        year: 42
      })
      |> FilmChecklist.Films.create_film()

    film
  end

  @doc """
  Generate a film.
  """
  def film_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        poster_url: "some poster_url",
        title: "some title",
        year: 42
      })

    {:ok, film} = FilmChecklist.Films.create_film(scope, attrs)
    film
  end
end
