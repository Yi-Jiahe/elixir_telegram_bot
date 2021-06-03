defmodule Homunculus.Router do
  use Plug.Router

  plug :match
  plug Plug.Parsers, parsers: [:json], json_decoder: JSON
  plug :dispatch

  # @token System.fetch_env("TOKEN") |> (fn {:ok, token } -> token end).()

  get "/" do
    send_resp(conn, 200, "Welcome")
  end
  
  # Route cannot follow Telegram's suggestion as the token contains invalid characters
  post "/post_updates" do
    # IO.inspect(conn.body_params)
    %{"message" => message} = conn.body_params
    %{"chat" => %{"id" => chat_id}, "text" => text} = message
    request_params = %{"chat_id" => chat_id, "text" => text}
    {:ok, request_body} = JSON.encode(request_params)
    {:ok, {{'HTTP/1.1', 200, 'OK'}, _headers, _body}} =
      :httpc.request(:post, {"#{baseurl()}/sendMessage", [], 'application/json', request_body}, [], [])
    send_resp(conn, 200, "Thanks")
  end

  match _ do
    send_resp(conn, 404, "Oops!")
  end

  defp baseurl do
    server = "https://api.telegram.org"
    {:ok, token} = System.fetch_env("TOKEN")
    server <> "/bot#{token}"
  end
end