defmodule AccomplishWeb.UserSessionHTML do
  use AccomplishWeb, :html

  import SaladUI.Form
  import AccomplishWeb.Components.OAuthComponents

  embed_templates "user_session_html/*"
end
