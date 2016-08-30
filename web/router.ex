defmodule Linker.Router do
  use Linker.Web, :router

  pipeline :default do
    plug :accepts, ["json"]
  end

  scope "/", Linker do
    pipe_through :default

    post "/", LinkController, :create
    get "/:id", LinkController, :show
    get "/:id/preview", LinkController, :preview
  end
end
