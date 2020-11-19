defmodule PrimosEmPiTest do
  use ExUnit.Case

  test "initial sequence" do
    assert PrimosEmPi.sequence(3.14159265358979323846) == 4159265358979323
  end
end
