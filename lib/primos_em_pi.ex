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
    |> Enum.map(&(String.to_integer(&1)))
  end

end
