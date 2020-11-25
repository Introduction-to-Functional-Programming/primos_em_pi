defmodule PrimosEmPiTest do
  use ExUnit.Case

  test "initial sequence" do
    assert PrimosEmPi.sequence(3.14159265358979323846) == 4_159_265_358_979_323
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

  test "Return if a number is prime" do
    assert PrimosEmPi.is_prime?(2)
    assert PrimosEmPi.is_prime?(3)
    assert PrimosEmPi.is_prime?(5)
    assert PrimosEmPi.is_prime?(59)
    assert PrimosEmPi.is_prime?(653)
    assert PrimosEmPi.is_prime?(9323)

    refute PrimosEmPi.is_prime?(6)
    refute PrimosEmPi.is_prime?(6598)
    refute PrimosEmPi.is_prime?(8541)
    refute PrimosEmPi.is_prime?(85)
  end

  test "Return if a string that represents a number is a prime number" do
    assert PrimosEmPi.is_prime?("653")
    assert PrimosEmPi.is_prime?("3")

    assert_raise ArgumentError, fn ->
      PrimosEmPi.is_prime?("A")
    end
  end

  test "Return the biggest prime number from a given list" do
    assert PrimosEmPi.biggest_prime([4, 4, 4, 4, 4]) == :error
    assert PrimosEmPi.biggest_prime([1, 2, 2, 2, 2]) == 2
    assert PrimosEmPi.biggest_prime([3, 1, 4, 1, 5]) == 41
    assert PrimosEmPi.biggest_prime([5, 9, 2, 6, 5]) == 59
    assert PrimosEmPi.biggest_prime([2, 6, 5, 3, 5]) == 653
    assert PrimosEmPi.biggest_prime([7, 9, 3, 2, 3]) == 9323

    assert PrimosEmPi.biggest_prime([1, 4, 1, 5, 9, 2, 6, 5, 3, 5, 8, 9, 7, 9, 3, 2, 3, 8, 4, 6]) ==
             9323
  end
end
