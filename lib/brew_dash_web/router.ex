defmodule BrewDashWeb.Router do
  use BrewDashWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_root_layout, {BrewDashWeb.Layouts, :root}
  end

  pipeline :admin do
    plug :auth
    plug :put_root_layout, {BrewDashWeb.Layouts, :admin}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BrewDashWeb do
    pipe_through :browser

    live_session :default do
      live "/", DashboardLive
      live "/taps", TapsDashboardLive
      live "/bottles", BottlesDashboardLive
      live "/history", HistoryLive
    end
  end

  scope "/api", BrewDashWeb.API do
    pipe_through :api

    resources "/taps", TapsController, only: [:index]
  end

  scope "/admin", BrewDashWeb.Admin do
    pipe_through :browser
    pipe_through :admin

    live_session :admin do
      live "/", AdminDashLive
      live "/bottles", BottlesListLive
      live "/bottles/:id/edit", BottleEditLive, :edit
      live "/bottles/new", BottleEditLive, :new
      live "/brews", BrewsListLive
      live "/brews/:id/edit", BrewEditLive, :edit
      live "/brews/new", BrewEditLive, :new
      live "/recipes", RecipesListLive
      live "/recipes/:id/edit", RecipeEditLive, :edit
      live "/recipes/new", RecipeEditLive, :new
      live "/csv_sync", CSVSyncLive
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", BrewDashWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  # credo:disable-for-next-line
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: BrewDashWeb.Telemetry
    end
  end

  defp auth(conn, _opts) do
    username = System.fetch_env!("AUTH_USERNAME")
    password = System.fetch_env!("AUTH_PASSWORD")
    Plug.BasicAuth.basic_auth(conn, username: username, password: password)
  end
end
