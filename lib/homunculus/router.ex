defmodule Homunculus.Router do
  use Plug.Router

  plug :match
  plug Plug.Parsers, parsers: [:json], json_decoder: JSON
  plug :dispatch

  alias Homunculus.Dispatcher

  # @token System.fetch_env("TOKEN") |> (fn {:ok, token } -> token end).()

  get "/" do
    send_resp(conn, 200, "Welcome")
  end
  
  # Route cannot follow Telegram's suggestion as the token contains invalid characters
  post "/post_updates" do
    # IO.inspect(conn.body_params)
    update = conn.body_params
    Dispatcher.dispatch(update)
    send_resp(conn, 200, "Thanks")
  end

  get "/ping" do
    send_resp(conn, 200, "pong")
  end 

  match _ do
    send_resp(conn, 404, "Oops!")
  end
end