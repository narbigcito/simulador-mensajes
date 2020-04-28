defmodule MessagesHelper do
  @moduledoc """
  Módulo que administra el envio de mensajes
  """

  def send_message(transmitter, receptor, channels, message) do
    {encoded, keys} = Huffman.encode(message)

    channel = TreeHelper.get_first_node(channels, transmitter, receptor)

    {:ok, steps} = SearchService.search(channels, channel, receptor, 0)

    message = Huffman.decode(encoded, keys)

    IO.puts("El mensaje pasó por #{steps} canales y es : #{message}")
  end
end