defmodule PrimosEmPi do
  def sequence(num) do
    num
    |> clean

    4159265358979323
  end

  def clean(num) do
    num
    |> to_string()
    |> String.graphemes()
    |> Enum.drop(2)
    |> Enum.map(&String.to_integer(&1))
  end

  def is_prime?(n) when n in [2, 3], do: true

  def is_prime?(x) do
    2..floor(:math.sqrt(x)) |> Enum.all?(fn y -> rem(x, y) != 0 end)
  end
end
