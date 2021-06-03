defmodule Homunculus.Dispatcher do
  @moduledoc """
  Dispatches updates to their relevant handlers
  """

  alias Homunculus.Commands
  alias Homunculus.Inline
  @doc """
  Dispatches updates by their content, i.e.
  Message or others
  """
  def dispatch(update) do
    case update do
      %{"message" => message} ->
        handle_message(message)
      %{"inline_query" => inline_query} ->
        handle_inline(inline_query)
      _ -> nil
    end
  end

  @doc """
  Dispatches message content updates
  """
  def handle_message(message) do
    case message do
      %{"entities" => entities, "text" => text} ->
        for entity <- entities, entity["type"] == "bot_command" do
          %{"offset" => offset, "length" => length} = entity
          command = String.slice(text, offset, length)
          case command do
            "/start" ->
              Commands.start(message)
            "/greet" ->
              Commands.greet(message)
            _ -> nil
          end
        end
      _ -> nil
    end
  end

  def handle_inline(inline_query) do
    %{"query" => query} = inline_query
    case query do
      "" -> Inline.help(inline_query)
      _ ->
        case String.split(query) do
          [command | _] ->
            case command do
              "rot13" -> Inline.rot13(inline_query)
              _ -> nil
            end
        end
    end
  end
end