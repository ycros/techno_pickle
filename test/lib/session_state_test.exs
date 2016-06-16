defmodule TechnoPickle.SessionStateTest do
  use ExUnit.Case
  doctest TechnoPickle.SessionState

  import TechnoPickle.SessionState, only: [ init: 1, handle_cast: 2 ]

  test "init" do
    expected = %TechnoPickle.Session{
      sequencers: %{
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
      },
      dispatch: "moo"
    }

    assert init(%{ dispatch: "moo" }) == {:ok, expected}
  end

  test "handle_cast :toggle updates state" do
    dispatch = fn(message, data) ->
      send self, {:dispatch_called, message, data}
    end

    before_session = %TechnoPickle.Session{
      sequencers: %{
        3 => %TechnoPickle.Sequencer{
          id: 3,
          width: 3,
          height: 3,
          grid: %{
            {0,0} => false,
            {0,1} => false
          }
        }
      },
      dispatch: dispatch
    }

    after_session = %TechnoPickle.Session{
      sequencers: %{
        3 => %TechnoPickle.Sequencer{
          id: 3,
          width: 3,
          height: 3,
          grid: %{
            {0,0} => false,
            {0,1} => true
          }
        }
      },
      dispatch: dispatch
    }

    assert handle_cast({:toggle, 3, {0,1}}, before_session)
      == {:noreply, after_session}

    assert_received {
      :dispatch_called,
      "set_position",
      %{sequencer_id: 3, position: [0,1], value: true},
    }
  end

  test "handle_cast :activate updates state" do
    dispatch = fn(message, data) ->
      send self, {:dispatch_called, message, data}
    end

    before_session = %TechnoPickle.Session{
      sequencers: %{
        3 => %TechnoPickle.Sequencer{
          active: true,
          id: 3,
        }
      },
      dispatch: dispatch
    }

    after_session = %TechnoPickle.Session{
      sequencers: %{
        3 => %TechnoPickle.Sequencer{
          active: false,
          id: 3,
        }
      },
      dispatch: dispatch
    }

    assert handle_cast({:active, 3}, before_session)
      == {:noreply, after_session}

    assert_received {
      :dispatch_called,
      "set_active",
      %{sequencer_id: 3, value: false}
    }
  end
end
