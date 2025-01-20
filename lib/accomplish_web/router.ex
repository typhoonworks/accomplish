defmodule AccomplishWeb.Router do
  use AccomplishWeb, :router

  import AccomplishWeb.Plugs.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {AccomplishWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AccomplishWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", AccomplishWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:accomplish, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: AccomplishWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview

      get "/swagger-ui", OpenApiSpex.Plug.SwaggerUI, path: "/api/openapi"
    end
  end

  ## Authentication routes

  scope "/", AccomplishWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update

    scope "/auth" do
      get "/:provider", OAuthController, :request
      get "/:provider/callback", OAuthController, :callback
      post "/:provider/callback", OAuthController, :callback

      post "/device/code", OAuthDeviceGrantController, :create_device_code
    end
  end

  scope "/", AccomplishWeb do
    pipe_through [:browser, :require_authenticated_user]

    scope "/auth" do
      get "/device/verify", OAuthDeviceGrantController, :verify_page
      post "/device/verify", OAuthDeviceGrantController, :verify_user_code
    end

    live_session :require_authenticated_user,
      on_mount: [{AccomplishWeb.Plugs.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
    end
  end

  scope "/", AccomplishWeb do
    pipe_through [:browser]

    post "/session/set-timezone", SessionTimezoneController, :set

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :edit
    post "/users/confirm/:token", UserConfirmationController, :update
  end

  scope "/api" do
    pipeline :public_api do
      plug :accepts, ["json"]
      plug(OpenApiSpex.Plug.PutApiSpec, module: AccomplishWeb.API.Spec)
    end

    pipeline :public_api_auth do
      plug(AccomplishWeb.Plugs.AuthorizePublicAPI)
    end

    scope "/spec" do
      pipe_through(:public_api)
      get "/openapi", OpenApiSpex.Plug.RenderSpec, []
      get "/swagger-ui", OpenApiSpex.Plug.SwaggerUI, path: "/api/spec/openapi"
    end

    scope "/v1", AccomplishWeb.API.V1 do
      pipe_through([:public_api, :public_api_auth])

      scope "/repositories" do
        get "/", RepositoriesController, :index, assigns: %{api_scope: "repositories:read"}

        post "/", RepositoriesController, :create_repository,
          assigns: %{api_scope: "repositories:write"}
      end
    end
  end
end
