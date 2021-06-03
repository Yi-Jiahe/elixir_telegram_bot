defmodule Homunculus.Commands do
  def start(message) do
    %{"chat" => %{"id" => chat_id}, "text" => text} = message
    case String.split(text) do
      [_ | tail] when tail != [] ->
        params = Enum.join(tail, " ")
        case params do
          "inline_help" ->
            request_params = %{"chat_id" => chat_id, "text" => "Inline commands:\n rot13 [message]"}
            {:ok, request_body} = JSON.encode(request_params)
            {:ok, {{'HTTP/1.1', 200, 'OK'}, _headers, _body}} = :httpc.request(:post, {Application.fetch_env!(:born_from_a_bottle_bot, :base_url) <> "/sendMessage", [], 'application/json', request_body}, [], [])
          _ -> nil
        end
      _ -> nil
    end
    IO.inspect(message)
  end

  def greet(message) do
    %{"chat" => %{"id" => chat_id}, "from" => %{"first_name" => first_name}} = message
    request_params = %{"chat_id" => chat_id, "text" => "Hi #{first_name}!"}
    {:ok, request_body} = JSON.encode(request_params)
    {:ok, {{'HTTP/1.1', 200, 'OK'}, _headers, _body}} = :httpc.request(:post, {Application.fetch_env!(:born_from_a_bottle_bot, :base_url) <> "/sendMessage", [], 'application/json', request_body}, [], [])
  end
end

