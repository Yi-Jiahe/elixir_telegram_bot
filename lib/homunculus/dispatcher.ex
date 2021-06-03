defmodule Homunculus.Dispatcher do
  @moduledoc """
  Dispatches updates to their relevant handlers
  """

  alias Homunculus.Commands

  @doc """
  Dispatches updates by their content, i.e.
  Message or others
  """
  def dispatch(update) do
    case update do
      %{"message" => message} ->
        handle_message(message)
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
            "/greet" ->
              Commands.greet(message)
          end
        end
      _ -> nil
    end
  end
end