defmodule InmanaWeb.WelcomeController do
  use InmanaWeb, :controller
  alias Inmana.Welcomer

  def index(conn, params) do
    params
    |> Welcomer.welcome()
    |> handle_response(conn)
  end

  defp handle_response({:ok, message}, conn) do
    render_response(conn, message, :ok)
  end

  defp handle_response({:error, message}, conn) do
    render_response(conn, message, :bad_request)
  end

  defp render_response(conn, message, status) do
    conn
    # Plug.Conn.put_status/2
    |> put_status(status)
    # Phoenix.Controller.json
    |> json(%{message: message})
  end
end
