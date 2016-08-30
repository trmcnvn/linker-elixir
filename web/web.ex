defmodule Linker.Web do
  @moduledoc """
  A module that keeps using definitions for controllers,
  views and so on.

  This can be used in your application as:

      use Linker.Web, :controller
      use Linker.Web, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below.
  """

  def model do
    quote do
      use Ecto.Schema

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
    end
  end

  def controller do
    quote do
      use Phoenix.Controller

      alias Linker.Repo
      import Ecto
      import Ecto.Query

      import Linker.Router.Helpers
      import Linker.Gettext
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "web/templates"

      import Linker.Router.Helpers
      import Linker.ErrorHelpers
      import Linker.Gettext
    end
  end

  def router do
    quote do
      use Phoenix.Router
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
