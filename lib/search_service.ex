defmodule SearchService do
  @moduledoc """
  Módulo que administra el algoritmo de busqueda.
  """

  def search(_channels, %{visited: true}, _, steps), do: steps

  def search(_channels, nil, _receptor, _steps) do
    {:error, "No existe ningún canal con el emisor seleccionado."}
  end

  def search(channels, channel, receptor, steps) do
      if Enum.member?(channel.actors, receptor) do
        {:ok, steps}
      else
        next_search(channels, channel, receptor, steps)
      end
  end

  defp next_search(channels, channel, receptor, steps) do
      channels = List.replace_at(channels, channel.index, Map.put(channel, :visited, true))
      search_references(channel.references, channels, receptor, steps)
  end

  defp search_references(references, channels, receptor, steps) do
    Enum.reduce(references, {:error, "Los nodos no tienen conexión"}, fn reference, _status ->
      search_reference(reference, channels, receptor, steps)
    end)
  end

  defp search_reference(reference, channels, receptor, steps) do
      channel = Enum.at(channels, reference)

      case search(channels, channel, receptor, steps + 1) do
        {:ok, steps} -> {:ok, steps}
        {:error, "Los nodos no tienen conexión"} -> {:error, "Los nodos no tienen conexión"}
        steps -> search(channels, channel, receptor, steps + 1)
      end
  end

end
