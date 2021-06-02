defmodule BrewDashWeb.PageController do
  use BrewDashWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
