defmodule FilmChecklist.Repo do
  use Ecto.Repo,
    otp_app: :film_checklist,
    adapter: Ecto.Adapters.Postgres
end
