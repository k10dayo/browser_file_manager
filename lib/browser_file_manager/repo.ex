defmodule BrowserFileManager.Repo do
  use Ecto.Repo,
    otp_app: :browser_file_manager,
    adapter: Ecto.Adapters.Postgres
end
