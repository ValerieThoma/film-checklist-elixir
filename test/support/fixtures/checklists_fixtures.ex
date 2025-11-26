defmodule FilmChecklist.ChecklistsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `FilmChecklist.Checklists` context.
  """

  @doc """
  Generate a checklist.
  """
  def checklist_fixture(attrs \\ %{}) do
    {:ok, checklist} =
      attrs
      |> Enum.into(%{
        completed: true,
        total_score: 42
      })
      |> FilmChecklist.Checklists.create_checklist()

    checklist
  end

  @doc """
  Generate a checklist_item.
  """
  def checklist_item_fixture(attrs \\ %{}) do
    {:ok, checklist_item} =
      attrs
      |> Enum.into(%{
        name: "some name",
        order_position: 42,
        point_value: 42,
        response_type: "some response_type",
        section: "some section"
      })
      |> FilmChecklist.Checklists.create_checklist_item()

    checklist_item
  end

  @doc """
  Generate a checklist_response.
  """
  def checklist_response_fixture(attrs \\ %{}) do
    {:ok, checklist_response} =
      attrs
      |> Enum.into(%{
        value: "some value"
      })
      |> FilmChecklist.Checklists.create_checklist_response()

    checklist_response
  end

  @doc """
  Generate a checklist.
  """
  def checklist_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        completed: true,
        total_score: 42
      })

    {:ok, checklist} = FilmChecklist.Checklists.create_checklist(scope, attrs)
    checklist
  end

  @doc """
  Generate a checklist_item.
  """
  def checklist_item_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        name: "some name",
        order_position: 42,
        point_value: 42,
        response_type: "some response_type",
        section: "some section"
      })

    {:ok, checklist_item} = FilmChecklist.Checklists.create_checklist_item(scope, attrs)
    checklist_item
  end

  @doc """
  Generate a checklist_response.
  """
  def checklist_response_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        value: "some value"
      })

    {:ok, checklist_response} = FilmChecklist.Checklists.create_checklist_response(scope, attrs)
    checklist_response
  end
end
