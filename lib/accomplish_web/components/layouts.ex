defmodule AccomplishWeb.Layouts do
  @moduledoc """
  This module holds different layouts used by your application.

  See the `layouts` directory for all templates available.
  The "root" layout is a skeleton rendered as part of the
  application router. The "app" layout is set as the default
  layout on both `use AccomplishWeb, :controller` and
  `use AccomplishWeb, :live_view`.
  """
  use AccomplishWeb, :html

  import AccomplishWeb.Shadowrun.Avatar
  import AccomplishWeb.Shadowrun.DropdownMenu
  import AccomplishWeb.Shadowrun.Menu
  import AccomplishWeb.Shadowrun.Sidebar

  embed_templates "layouts/*"
end
