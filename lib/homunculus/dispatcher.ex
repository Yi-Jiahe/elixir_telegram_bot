defmodule Homunculus.Dispatcher do
  def dispatch(update) do
    %{"message" => message} = update
    %{"chat" => %{"id" => chat_id}, "text" => text} = message
      request_params = %{"chat_id" => chat_id, "text" => text}
    {:ok, request_body} = JSON.encode(request_params)
    {:ok, {{'HTTP/1.1', 200, 'OK'}, _headers, _body}} =
      :httpc.request(:post, {"#{baseurl()}/sendMessage", [], 'application/json', request_body}, [], [])
  end

  defp baseurl do
    server = "https://api.telegram.org"
    {:ok, token} = System.fetch_env("TOKEN")
    server <> "/bot#{token}"
  end
end