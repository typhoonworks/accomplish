defmodule AccomplishWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, components, channels, and so on.

  This can be used in your application as:

      use AccomplishWeb, :controller
      use AccomplishWeb, :html

  The definitions below will be executed for every controller,
  component, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define additional modules and import
  those modules here.
  """

  def static_paths, do: ~w(assets fonts images favicon.ico robots.txt)

  def router do
    quote do
      use Phoenix.Router, helpers: false

      # Import common connection and controller functions to use in pipelines
      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
    end
  end

  def controller do
    quote do
      use Phoenix.Controller,
        formats: [:html, :json],
        layouts: [html: AccomplishWeb.Layouts]

      use Gettext, backend: AccomplishWeb.Gettext

      import Plug.Conn

      unquote(verified_routes())
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView

      unquote(html_helpers())
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(html_helpers())
    end
  end

  def html do
    quote do
      use Phoenix.Component

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_csrf_token: 0, view_module: 1, view_template: 1]

      # Include general helpers for rendering HTML
      unquote(html_helpers())
    end
  end

  defp html_helpers do
    quote do
      # Translation
      use Gettext, backend: AccomplishWeb.Gettext

      # HTML escaping functionality
      import Phoenix.HTML
      # Core UI components
      import AccomplishWeb.CoreComponents
      import AccomplishWeb.ShadowrunComponents

      import AccomplishWeb.TimeHelpers

      # Shortcut for generating JS commands
      alias Phoenix.LiveView.JS

      # Routes generation with the ~p sigil
      unquote(verified_routes())
    end
  end

  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: AccomplishWeb.Endpoint,
        router: AccomplishWeb.Router,
        statics: AccomplishWeb.static_paths()
    end
  end

  def open_api_schema do
    quote do
      require OpenApiSpex
      alias OpenApiSpex.Schema
      alias AccomplishWeb.API.Schemas
    end
  end

  def api_controller do
    quote do
      use AccomplishWeb, :controller

      alias AccomplishWeb.API.Helpers
    end
  end

  def public_api_controller do
    quote do
      use AccomplishWeb, :controller
      use OpenApiSpex.ControllerSpecs

      alias AccomplishWeb.API.Schemas
      alias AccomplishWeb.API.Helpers

      plug(OpenApiSpex.Plug.CastAndValidate, json_render_error_v2: true, replace_params: false)

      use OpenApiSpex.ControllerSpecs
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/live_view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
