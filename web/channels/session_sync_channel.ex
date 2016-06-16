defmodule TechnoPickle.SessionSyncChannel do
  use Phoenix.Channel

  def join("session:sync", _message, socket) do
    # push socket, 'state', TechnoPickle.SessionState.get_state()
    send self, :after_join
    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
    push socket, "state", TechnoPickle.SessionState.get_state()
    {:noreply, socket}
  end

  def handle_in("toggle_sequencer_position", data, socket) do
    # broadcast_from! socket, "toggle_sequencer_position", data
    %{"sequencer_id" => sequencer_id, "position" => position} = data
    TechnoPickle.SessionState.toggle_position(sequencer_id, List.to_tuple(position))
    {:reply, :ok, socket}
  end

  def handle_in("toggle_sequencer", data, socket) do
    %{"sequencer_id" => sequencer_id} = data
    TechnoPickle.SessionState.toggle_active(sequencer_id)
    {:reply, :ok, socket}
  end

end
