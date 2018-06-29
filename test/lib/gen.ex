defmodule ValetTest.Gen do
  
  alias StreamData, as: SD
  import ExUnitProperties
  
  def such_that_not_all(gen, pred),
    do: Enum.filter(gen, fn l -> Enum.any?(l, &(!pred.(&1))) end)
  

  def non_negative_integer, do: SD.map(SD.positive_integer(), &(&1-1))
  
  def number, do: SD.one_of([SD.integer(), SD.float()])
  def number_between(min, max), do: SD.one_of([SD.integer(min..max), SD.float(min..max)])
  
  def int_at_least(n),  do: (gen all i <- non_negative_integer(), do: (n + i))
  def int_at_most(n),   do: (gen all i <- non_negative_integer(), do: (n - i))
  def int_less_than(n), do: (gen all i <- SD.positive_integer(),  do: (n - i))
  def int_more_than(n), do: (gen all i <- SD.positive_integer(),  do: (n + i))
  def int_between(min, max), do: SD.integer(min..max)
  
  def integer_nonempty_range() do
    gen all lower <- SD.integer(),
            count <- SD.positive_integer(),
      do: {lower, count + lower}
  end
  
  @doc """
  {toosmall, toobig, inrange}
  """
  def int_range_samples(lower, upper) do
    gen all toosmall <- int_less_than(lower),
            toobig <- int_more_than(upper),
            inrange <- int_between(lower, upper),
      do: {toosmall, toobig, inrange}
  end
  
  def int_test() do
    gen all {lower, upper} <- integer_nonempty_range(),
            {toosmall, toobig, inrange} <- int_range_samples(lower, upper),
      do: {lower, upper, toosmall, toobig, inrange}
  end
  
  def float_test do
    gen all t <- int_test() do
      Tuple.to_list(t)
      |> Enum.map(&(0.0 + &1))
      |> List.to_tuple()
    end
  end
  
  def binary_test do
    gen all lower <- SD.positive_integer(), # positive means we can always take 1 off it
            count <- SD.positive_integer(),
            upper = lower + count,
            toosmall <- SD.binary(max_length: lower - 1),
            toobig <- SD.binary(min_length: upper + 1),
            inrange <- SD.binary(min_length: lower, max_length: upper),
      do: {lower, upper, toosmall, toobig, inrange}
  end

  def string_test do
    gen all lower <- SD.positive_integer(), # positive means we can always take 1 off it
            count <- SD.positive_integer(),
            upper = lower + count,
            toosmall <- SD.string(:alphanumeric, max_length: lower - 1),
            toobig <- SD.string(:alphanumeric, min_length: upper + 1),
            inrange <- SD.string(:alphanumeric, min_length: lower, max_length: upper),
      do: {lower, upper, toosmall, toobig, inrange}
  end
  
  def list_test do
    gen all lower <- SD.positive_integer(), # positive means we can always take 1 off it
            count <- SD.positive_integer(),
            upper = lower + count,
            toosmall <- SD.list_of(SD.integer(), max_length: lower - 1),
            toobig   <- SD.list_of(SD.integer(), min_length: upper + 1),
            inrange  <- SD.list_of(SD.integer(), min_length: lower, max_length: upper),
      do: {lower, upper, toosmall, toobig, inrange}
  end

  # Note: integers work badly as keys
  def map_test do
    gen all lower <- SD.positive_integer(), # positive means we can always take 1 off it
            count <- SD.positive_integer(),
            upper = lower + count,
            toosmall <- SD.map_of(SD.binary(), SD.integer(), max_length: lower - 1),
            toobig   <- SD.map_of(SD.binary(), SD.integer(), min_length: upper + 1),
            inrange  <- SD.map_of(SD.binary(), SD.integer(), min_length: lower, max_length: upper),
      do: {lower, upper, toosmall, toobig, inrange}
  end
end
