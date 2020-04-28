defmodule Simulation do
  @moduledoc """
  Simula un flujo de mensajes
  """

  def run(transmitter, receiver, actors \\ [:a, :b, :c, :d], total_channels \\ 5) do
    channels = TreeHelper.create_graph(actors, total_channels)
    IO.inspect(channels, label: "Árbol")

    message = "Mi vida es más fácil con Elixir"

    MessagesHelper.send_message(transmitter, receiver, channels, message)

  end

end
