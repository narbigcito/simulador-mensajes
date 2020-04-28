defmodule TreeHelper do
  @moduledoc """
  Módulo que administra los procesos de grafos.
  """

  def create_graph(actors, total_channels) do
    1..total_channels
    |> Enum.reduce([], fn i, channel ->
      insert_node(actors, total_channels, channel, i)
    end)
    |> create_references()
  end

  defp insert_node(actors, total_channels, channel, index) do
    node = %{references: [], visited: false, index: total_channels - index}
    [Map.put(node, :actors, get_random_actors(actors)) | channel]
  end

  def get_first_node(channels, transmitter, receptor) do
    channel =
      Enum.find(channels, fn %{actors: actors} ->
        Enum.member?(actors, transmitter) and Enum.member?(actors, receptor)
      end)

    if(is_nil(channel)) do
      Enum.find(channels, fn %{actors: actors} -> Enum.member?(actors, transmitter) end)
    else
      channel
    end
  end

  defp get_random_actors(actors) do
    Enum.reduce(actors, [], fn actor, random_actors ->
      insert_actor(actor, random_actors)
    end)
  end

  defp insert_actor(actor, random_actors) do
    case :rand.uniform(2) do
      1 -> [actor | random_actors]
      2 -> random_actors
    end
  end

  defp create_references(channels) do
    {channels, _i} =
      Enum.map_reduce(channels, 0, fn %{actors: actors} = channel, index ->
        references = create_references(actors, channels, index)
        channel = Map.put(channel, :references, references)
        {channel, index + 1}
      end)

    channels
  end

  defp create_references(actors, channels, channel, index) do
    references = create_references(actors, channels, index)
    channel = Map.put(channel, :references, references)
    {channel, index + 1}
  end

  defp create_references(actors, channels, current_index) do
    {_i, references} =
      channels
      |> Enum.reduce({0, []}, fn channel, {index, indexes} ->
        create_reference(channel, actors, index, indexes)
      end)

    Enum.reject(references, fn index -> index == current_index end)
  end

  defp create_reference(%{actors: actors}, channel_actors, index, indexes) do
    actors
    |> has_connection?(actors)
    |> create_reference(index, indexes)
  end

  defp create_reference(true, index, indexes), do: {index + 1, [index | indexes]}

  defp create_reference(false, index, indexes), do: {index + 1, indexes}

  defp has_connection?(actors, channel_actors) do
    Enum.any?(actors, fn actor ->
      Enum.member?(channel_actors, actor)
    end)
  end
end