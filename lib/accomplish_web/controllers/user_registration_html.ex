defmodule AccomplishWeb.UserRegistrationHTML do
  use AccomplishWeb, :html

  import SaladUI.Form
  import AccomplishWeb.Components.OAuthComponents

  embed_templates "user_registration_html/*"
end
