defmodule FilmChecklistWeb.PageController do
  use FilmChecklistWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
