defmodule TechnoPickle.StructSequencerTest do
  use ExUnit.Case
  doctest TechnoPickle.Sequencer

  import TechnoPickle.Sequencer, only: [ build_grid: 2 ]

  test "build_grid builds grid" do
    grid = build_grid(2, 3)
    assert grid == %{
      {0,0} => false,
      {0,1} => false,
      {0,2} => false,
      {1,0} => false,
      {1,1} => false,
      {1,2} => false,
    }
  end
end
