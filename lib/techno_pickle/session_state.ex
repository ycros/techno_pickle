defmodule TechnoPickle.SessionState do
  use GenServer

  def toggle_position(sequencer_id, position) do
    GenServer.cast(__MODULE__, {:toggle, sequencer_id, position})
  end

  def toggle_active(sequencer_id) do
    GenServer.cast(__MODULE__, {:active, sequencer_id})
  end

  def get_state() do
    GenServer.call(__MODULE__, :get_state)
  end

  def start_link(args) do
    GenServer.start(__MODULE__, args, name: __MODULE__)
  end

  def init(%{ dispatch: dispatch }) do
    sequencers = %{
      0 => %TechnoPickle.Sequencer{
        id: 0,
        width: 16,
        height: 5,
        grid: TechnoPickle.Sequencer.build_grid(16, 5)
      },
      1 => %TechnoPickle.Sequencer{
        id: 1,
        width: 16,
        height: 2,
        grid: TechnoPickle.Sequencer.build_grid(16, 2)
      },
    }

    session = %TechnoPickle.Session{ sequencers: sequencers, dispatch: dispatch }

    {:ok, session}
  end

  def handle_call(:get_state, _from, session) do
    state = Map.delete(session, :dispatch)
    state = update_in(state.sequencers, &keys_to_strings/1)
    {:reply, state, session}
  end

  defp keys_to_strings(sequencers) do
    sequencers
    |> Enum.map(fn ({k, v}) -> {to_string(k), transform_sequencer(v)} end)
    |> Enum.into(%{})
  end

  defp pos_to_string({x,y}) do
    "#{x},#{y}"
  end

  defp grid_keys_to_strings(grid) do
    grid
    |> Enum.map(fn ({k, v}) -> {pos_to_string(k), v} end)
    |> Enum.into(%{})
  end

  defp transform_sequencer(sequencer) do
    update_in(sequencer.grid, &grid_keys_to_strings/1)
  end

  def handle_cast({:toggle, sequencer_id, position}, session) do
    {value, new_session} = get_and_update_in(
      session.sequencers[sequencer_id].grid[position],
      &{!&1, !&1})

    session.dispatch.(
      "set_position",
      %{
        sequencer_id: sequencer_id,
        position: Tuple.to_list(position),
        value: value})

    {:noreply, new_session}
  end

  def handle_cast({:active, sequencer_id}, session) do
    {value, new_session} = get_and_update_in(
      session.sequencers[sequencer_id].active,
      &{!&1, !&1})

      session.dispatch.(
        "set_active",
        %{sequencer_id: sequencer_id, value: value}
      )

      {:noreply, new_session}
  end

  # TODO: refactor out into reducers
  # def handle_cast(action, _from, session) do
  #   {:noreply, reduce_session(action, session)}
  # end
  #
  # def reduce_session(action, session) do
  #   %TechnoPickle.Session{
  #     sequencers: reduce_sequencers(action, session.sequencers),
  #     dispatch: session.dispatch
  #   }
  # end
  #
  # def reduce_sequencers(%{sequencer_id: sequencer_id} = action, sequencers) do
  #   Map.put sequencers,
  #     sequencer_id,
  #     reduce_sequencer(action, sequencers[sequencer_id])
  # end
  #
  # def reduce_sequencers(_action, sequencers) do
  #   sequencers
  # end
  #
  # def reduce_sequencer(action, sequencer) do
  #   case action.type do
  #     :toggle ->
  #       update_in(sequencer.grid[action.position], &(!&1))
  #
  #   end
  # end
end
