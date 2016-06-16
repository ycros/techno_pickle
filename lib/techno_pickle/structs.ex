defmodule TechnoPickle.Session do
  defstruct sequencers: %{}, dispatch: nil
end

defmodule TechnoPickle.Sequencer do
  defstruct id: nil, active: true, width: nil, height: nil, grid: nil

  def build_grid(width, height) do
    0..width - 1
    |> Enum.flat_map(fn x -> build_cols(x, height) end)
    |> Enum.map(fn key -> {key, false} end)
    |> Enum.into(%{})
  end

  defp build_cols(x, height) do
    0..height - 1
    |> Enum.map(fn y -> {x, y} end)
  end
end
