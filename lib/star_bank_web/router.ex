defmodule StarBankWeb.Router do
  use StarBankWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug StarBankWeb.Plugs.Auth
  end

  scope "/api", StarBankWeb do
    pipe_through :api

    post "/users", Users.UsersController, :create
    get "/", WelcomeController, :index
    post "/users/login", Users.UsersController, :login
  end

  scope "/api", StarBankWeb do
    pipe_through [:api, :auth]

    resources "/users", Users.UsersController, only: [:update, :delete, :show]

    post "/accounts", Accounts.AccountsController, :create
    post "/accounts/transaction", Accounts.AccountsController, :transaction
  end

  # Enable LiveDashboard in development
  if Application.compile_env(:star_bank, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: StarBankWeb.Telemetry
    end
  end
end
