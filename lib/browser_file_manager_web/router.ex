defmodule BrowserFileManagerWeb.Router do
  use BrowserFileManagerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {BrowserFileManagerWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BrowserFileManagerWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/copyright", PageController, :copyright

    live "/live", ManagerLive, :index
    live "/live/new", ManagerLive, :new
    live "/live/new/:id", ManagerLive, :new_id
    live "/live/:id/edit", ManagerLive, :edit

    live "live/search", ManagerLive, :search

    live "/image_view", ImageView

    resources "/properties", PropertyController
    resources "/tags", TagController
    resources "/files", FileController
  end

  # Other scopes may use custom stacks.
  # scope "/api", BrowserFileManagerWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:browser_file_manager, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: BrowserFileManagerWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
