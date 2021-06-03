defmodule Homunculus.Commands do
  @moduledoc """
  Handles commands sent to the bot
  """
  
  @doc """
  Provides information on how to use the bot
  """
  def start(message) do
    %{"chat" => %{"id" => chat_id}, "text" => text} = message
    case String.split(text) do
      [_ | tail] when tail != [] ->
        params = Enum.join(tail, " ")
        case params do
          "inline_help" ->
            {:ok, request_body} = JSON.encode(%{"chat_id" => chat_id, "text" => "Inline commands:\n`rot13 [message]`\n\tApplies a ROT13 subsitution cipher to `message`", "parse_mode" => "markdown"})
            {:ok, {{'HTTP/1.1', 200, 'OK'}, _headers, _body}} = :httpc.request(:post, {Application.fetch_env!(:born_from_a_bottle_bot, :base_url) <> "/sendMessage", [], 'application/json', request_body}, [], [])
            # switch_inline_query button immediately switches user back to their original chat without giving time for them to read the documentation
            #{:ok, request_body} = JSON.encode(%{"chat_id" => chat_id, "text" => "Inline commands:\n rot13 [message]\n\tApplies a ROT13 subsitution cipher to the message", "reply_markup" => %{"inline_keyboard" => [[%{"text" => "Use me!", "switch_inline_query" => ""}]]}})
            #{:ok, {{'HTTP/1.1', 200, 'OK'}, _headers, _body}} = :httpc.request(:post, {Application.fetch_env!(:born_from_a_bottle_bot, :base_url) <> "/sendMessage", [], 'application/json', request_body}, [], [])
          _ -> nil
        end
      _ -> nil
    end
  end

  def greet(message) do
    %{"chat" => %{"id" => chat_id}, "from" => %{"first_name" => first_name}} = message
    request_params = %{"chat_id" => chat_id, "text" => "Hi #{first_name}!"}
    {:ok, request_body} = JSON.encode(request_params)
    {:ok, {{'HTTP/1.1', 200, 'OK'}, _headers, _body}} = :httpc.request(:post, {Application.fetch_env!(:born_from_a_bottle_bot, :base_url) <> "/sendMessage", [], 'application/json', request_body}, [], [])
  end
end

