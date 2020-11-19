defmodule PrimosEmPiTest do
  use ExUnit.Case

  test "initial sequence" do
    assert PrimosEmPi.sequence(3.14159265358979323846) == 4159265358979323
  end

  test "clean" do
    assert PrimosEmPi.clean(3.14159265358979323846) == [
             1,
             4,
             1,
             5,
             9,
             2,
             6,
             5,
             3,
             5,
             8,
             9,
             7,
             9,
             3
           ]
  end

  test "is_prime?" do
    assert(PrimosEmPi.is_prime?(2))
    assert(PrimosEmPi.is_prime?(3))
    refute(PrimosEmPi.is_prime?(4))
    assert(PrimosEmPi.is_prime?(5))
  end
end
