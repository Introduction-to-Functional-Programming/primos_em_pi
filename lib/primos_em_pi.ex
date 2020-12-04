defmodule PrimosEmPi do
  def sequence(num) do
    num
    |> clean

    4_159_265_358_979_323
  end

  def clean(num) do
    num
    |> to_string()
    |> String.graphemes()
    |> Enum.drop(2)
    |> Enum.map(&String.to_integer(&1))
  end

  # def is_prime?(n) when n in [2, 3], do: true

  # def is_prime?(x) do
  #   2..floor(:math.sqrt(x)) |> Enum.all?(fn y -> rem(x, y) != 0 end)
  # end

  # Código Cristine

  @max_digits_constant 4

  def biggest_prime(numbers) do
    numbers
    |> Enum.join()
    |> do_biggest_prime(max_digits(numbers))
  end

  def do_biggest_prime(numbers_as_string, max_digits) do
    numbers_as_string
    |> slices(max_digits)
    # |> Enum.sort(fn x, y -> String.to_integer(x) > String.to_integer(y) end)
    |> check(numbers_as_string, max_digits)
  end

  def check(slices, numbers, max_digits) do
    slices
    |> Enum.filter(&is_prime?/1)
    |> primes(numbers, max_digits)
  end

  def primes([], _numbers, 1) do
    :error
  end

  def primes([], numbers, acc) do
    numbers
    |> do_biggest_prime(acc - 1)
  end

  def primes(primes, _numbers, _acc) do
    primes
    |> Enum.map(&String.to_integer/1)
    |> Enum.max()
  end

  def slices(_, size) when size <= 0, do: []

  def slices(s, size) do
    max = String.length(s)
    for iterate <- 0..max, iterate + size <= max, do: String.slice(s, iterate, size)
  end

  def max_digits(numbers) when length(numbers) < @max_digits_constant, do: length(numbers)
  def max_digits(_), do: @max_digits_constant

  @spec biggest_sequence(binary) :: {<<>>, binary, bitstring}

  def old_biggest_sequence(number) when is_list(number) do
    number
    |> as_string()
    |> old_biggest_sequence()
  end

  def old_biggest_sequence(number) do
    number
    |> number_to_slices()
    |> get_all_primes()
    |> find_duplicated_primes()
    |> remove_duplicated_primes()
    |> remove_special_cases()
    |> find_diffs(number)
    |> find_biggest_sequence()
  end

  def number_to_slices(number) do
    number
    |> String.graphemes()
    |> Stream.unfold(fn n -> {Enum.take(n, 4), tl(n)} end)
    |> Enum.take(String.length(number))
  end

  def get_all_primes(slices) do
    slices
    |> Enum.map(&slice_to_combinations/1)
    |> Enum.map(&filter_primes/1)
    |> List.flatten()
  end

  def slice_to_combinations(slice) do
    slice
    |> Enum.reverse()
    |> Stream.unfold(fn n -> {Enum.take(n, length(n)), tl(n)} end)
    |> Enum.take(length(slice))
    |> Enum.reverse()
    |> Enum.map(&Enum.reverse/1)
    |> Enum.map(&Enum.join/1)
  end

  def filter_primes(combinations) do
    combinations
    |> Enum.filter(&is_prime?/1)
  end

  def find_duplicated_primes(original_primes) do
    original_primes
    |> Enum.with_index()
    |> find_duplicated_primes(original_primes, [])
  end

  def find_duplicated_primes([], original_primes, acc) do
    acc
    |> List.flatten()
    |> Enum.sort()
    |> Enum.uniq()
    |> (&{&1, original_primes}).()
  end

  def find_duplicated_primes(list_of_primes, original_primes, acc) do
    current = hd(list_of_primes)
    primes = all_primes(elem(current, 0))
    index = primes |> Enum.find_index(&(&1 == elem(current, 0)))
    size = primes |> length()

    list_to_remove =
      Enum.filter(0..(size - 1), fn x -> x != index end)
      |> adjust_indexes(elem(current, 1), index)

    acc = [list_to_remove | acc]
    find_duplicated_primes(tl(list_of_primes), original_primes, acc)
  end

  def remove_duplicated_primes({indexes, list}) do
    indexes
    |> Enum.reduce(list, &List.replace_at(&2, &1, "0"))
    |> Enum.filter(&(&1 != "0"))
  end

  def remove_special_cases(cleaned) do
    cleaned
    |> special_case([])
    |> Enum.zip(cleaned)
    |> Keyword.get_values(false)
    |> Enum.join()
  end

  def find_diffs(primes, number) do
    primes
    |> String.reverse()
    |> String.myers_difference(String.reverse(number))
    |> Keyword.get_values(:eq)
  end

  def find_biggest_sequence(diffs) do
    diffs
    |> Enum.map(&String.reverse/1)
    |> Enum.reverse()
    |> Enum.max_by(&String.length/1)
  end

  def is_prime?(n) when is_binary(n), do: is_prime?(String.to_integer(n))
  def is_prime?(n) when n in [2, 3], do: true

  def is_prime?(n) when n <= 9973 do
    Enum.to_list(2..floor(:math.sqrt(n)))
    |> calc(n)
  end

  def is_prime?(_n), do: false

  defp calc([h | _t], n) when rem(n, h) == 0, do: false
  defp calc([_h | t], n), do: calc(t, n)
  defp calc([], _n), do: true

  defp as_string(number) when is_binary(number), do: number
  defp as_string(number), do: Enum.join(number)

  defp adjust_indexes(indexes, index, _adjust) when index <= 1, do: indexes

  defp adjust_indexes(indexes, index, adjust) do
    indexes
    |> Enum.map(&(&1 - adjust))
    |> Enum.map(&(&1 + index))
  end

  defp special_case([a, b, c | _rest] = list, acc) do
    last = String.graphemes(a) |> List.last()
    current = b
    next = String.graphemes(c) |> List.first()
    acc = [special_case?(last, current, next) | acc]
    special_case(tl(list), acc)
  end

  defp special_case(_, acc), do: [false | acc] |> Enum.reverse() |> (&[false | &1]).()

  defp special_case?(a, b, c) do
    Enum.join([a, c]) == b
  end

  # For test purposes only
  def all_primes(number) do
    number
    |> as_string()
    |> number_to_slices()
    |> get_all_primes()
  end

  # 04/12/2020

  def biggest_sequence(number_as_string) do
    do_biggest_sequence(number_as_string, [])
    |> Enum.reverse()
    |> IO.inspect()
    |> Enum.join()
  end

  def do_biggest_sequence("", list_of_primes) do
    list_of_primes
  end

  def do_biggest_sequence(number_as_string, list_of_primes) do
    # IO.inspect(list_of_primes)
    {first_n, rest} = split_at_first_n_characters(number_as_string, @max_digits_constant)
    {before_prime, prime, after_prime} = split_at_biggest_prime(first_n)
    # {before_prime, prime, after_prime} |> IO.inspect()
    continue_sequence({before_prime, prime, after_prime}, rest, list_of_primes)
  end

  def continue_sequence({_, prime, ""}, "", list_of_primes) do
    [prime | list_of_primes]
  end

  def continue_sequence({_before_prime, "", after_prime}, rest, list_of_primes) do
    do_biggest_sequence(String.slice(after_prime <> rest, 1..-1), list_of_primes)
  end

  def continue_sequence({_before_prime, prime, after_prime}, rest, list_of_primes) do
    # IO.inspect(after_prime)
    # IO.inspect(rest)
    # IO.inspect(prime)
    # IO.inspect([prime | list_of_primes])
    do_biggest_sequence(after_prime <> rest, [prime | list_of_primes])
  end

  def split_at_biggest_prime(string) do
    do_split_at_biggest_prime(string, "", "", "")
  end

  def do_split_at_biggest_prime("", before_prime, prime, after_prime) do
    {before_prime, prime, after_prime}
  end

  def do_split_at_biggest_prime(origin, before_prime, prime, after_prime) do
    cond do
      is_prime?(origin) ->
        {"", origin, after_prime}

      true ->
        {new_origin, last_char} = String.split_at(origin, String.length(origin) - 1)
        do_split_at_biggest_prime(new_origin, before_prime, prime, last_char <> after_prime)
    end
  end

  defp split_at_first_n_characters(string, n) do
    String.split_at(string, min(n, String.length(string)))
  end
end
