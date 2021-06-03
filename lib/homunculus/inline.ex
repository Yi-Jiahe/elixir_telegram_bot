defmodule Homunculus.Inline do
  def help(inline_query) do
    %{"id" => id} = inline_query
    {:ok, request_body} = JSON.encode(%{"inline_query_id" => id, "results" => [], "switch_pm_text" => "Get help with inline commands", "switch_pm_parameter" => "inline_help"})
    {:ok, {{'HTTP/1.1', 200, 'OK'}, _headers, _body}} = :httpc.request(:post, {Application.fetch_env!(:born_from_a_bottle_bot, :base_url) <> "/answerInlineQuery", [], 'application/json', request_body}, [], [])
  end

  def rot13(inline_query) do
    %{"id" => id, "query" => query} = inline_query
    case String.split(query) do
      [_ | tail] when tail != [] ->
        {:ok, text} = Rot13.encode(Enum.join(tail, " "))
        results = [%{"type" => "article", "id" => 1, "title" => "Encode", "input_message_content" => %{"message_text" => text}, "description" => text}]
        IO.inspect(results)
        {:ok, request_body} = JSON.encode(%{"inline_query_id" => id, "results" => results})
        # IO.inspect(request_body)
        {:ok, {{'HTTP/1.1', 200, 'OK'}, _headers, _body}} = :httpc.request(:post, {Application.fetch_env!(:born_from_a_bottle_bot, :base_url) <> "/answerInlineQuery", [], 'application/json', request_body}, [], [])
      _ -> nil
    end
  end
end