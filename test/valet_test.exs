defmodule ValetTest do
  use ExUnit.Case
  use ExUnitProperties
  alias Valet.Schema
  alias StreamData, as: SD
  alias ValetTest.Gen
  alias Valet.Error.{
    NotAtLeast,       NotAtMost,       NotBetween,
    LengthNotAtLeast, LengthNotAtMost, LengthNotBetween,
  }

  doctest Valet
  doctest Valet.Integer
  doctest Valet.Float
  doctest Valet.Number
  doctest Valet.Binary
  doctest Valet.String
  doctest Valet.Tuple
  doctest Valet.List
  doctest Valet.Map
  doctest Valet.Every
  doctest Valet.Choice
  doctest Valet.Union

  property "integer" do
    check all {lower, upper, toosmall, toobig, inrange} <- Gen.int_test() do
      min = Valet.integer(min: lower)
      max = Valet.integer(max: upper)
      minmax = Valet.integer(min: lower, max: upper)
      mins = [min, minmax]
      maxs = [max, minmax]

      for m <- mins, do: assert [] === Schema.validate(m, inrange)
      for m <- maxs, do: assert [] === Schema.validate(m, inrange)
       
      assert [NotAtLeast.new([], toosmall, lower)] === Schema.validate(min, toosmall)
      assert [NotBetween.new([], toosmall, lower, upper)] === Schema.validate(minmax, toosmall)

      assert [NotAtMost.new([],  toobig, upper)] === Schema.validate(max, toobig)
      assert [NotBetween.new([], toobig, lower, upper)] === Schema.validate(minmax, toobig)
    end
  end

  # What is all this funky casting of integer about, you ask? perhaps
  # predictably, stream_data picked something that would overflow
  # fairly quickly with float()
  property "float" do
    check all {lower, upper, toosmall, toobig, inrange} <- Gen.float_test() do

      min = Valet.float(min: lower)
      max = Valet.float(max: upper)
      minmax = Valet.float(min: lower, max: upper)
      mins = [min, minmax]
      maxs = [max, minmax]

      for m <- mins, do: assert [] === Schema.validate(m, inrange)
      for m <- maxs, do: assert [] === Schema.validate(m, inrange)
       
      assert [NotAtLeast.new([], toosmall, lower)] === Schema.validate(min, toosmall)
      assert [NotBetween.new([], toosmall, lower, upper)] === Schema.validate(minmax, toosmall)

      assert [NotAtMost.new([],  toobig, upper)] === Schema.validate(max, toobig)
      assert [NotBetween.new([], toobig, lower, upper)] === Schema.validate(minmax, toobig)
    end
  end

  property "number - int" do
    check all {lower, upper, toosmall, toobig, inrange} <- Gen.int_test() do

      min = Valet.number(min: lower)
      max = Valet.number(max: upper)
      minmax = Valet.number(min: lower, max: upper)
      mins = [min, minmax]
      maxs = [max, minmax]

      for m <- mins, do: assert [] === Schema.validate(m, inrange)
      for m <- maxs, do: assert [] === Schema.validate(m, inrange)
       
      assert [NotAtLeast.new([], toosmall, lower)] === Schema.validate(min, toosmall)
      assert [NotBetween.new([], toosmall, lower, upper)] === Schema.validate(minmax, toosmall)

      assert [NotAtMost.new([],  toobig, upper)] === Schema.validate(max, toobig)
      assert [NotBetween.new([], toobig, lower, upper)] === Schema.validate(minmax, toobig)
    end
  end

  property "number - float" do
    check all {lower, upper, toosmall, toobig, inrange} <- Gen.float_test() do

      min = Valet.number(min: lower)
      max = Valet.number(max: upper)
      minmax = Valet.number(min: lower, max: upper)
      mins = [min, minmax]
      maxs = [max, minmax]

      for m <- mins, do: assert [] === Schema.validate(m, inrange)
      for m <- maxs, do: assert [] === Schema.validate(m, inrange)
       
      assert [NotAtLeast.new([], toosmall, lower)] === Schema.validate(min, toosmall)
      assert [NotBetween.new([], toosmall, lower, upper)] === Schema.validate(minmax, toosmall)

      assert [NotAtMost.new([],  toobig, upper)] === Schema.validate(max, toobig)
      assert [NotBetween.new([], toobig, lower, upper)] === Schema.validate(minmax, toobig)
    end
  end

  property "binary" do
    check all {lower, upper, toosmall, toobig, inrange} <- Gen.binary_test() do
      min = Valet.binary(min_len: lower)
      max = Valet.binary(max_len: upper)
      minmax = Valet.binary(min_len: lower, max_len: upper)
      mins = [min, minmax]
      maxs = [max, minmax]

      for m <- mins, do: assert [] === Schema.validate(m, inrange)
      for m <- maxs, do: assert [] === Schema.validate(m, inrange)
       
      assert [LengthNotAtLeast.new([], toosmall, lower)] === Schema.validate(min, toosmall)
      assert [LengthNotBetween.new([], toosmall, lower, upper)] === Schema.validate(minmax, toosmall)

      assert [LengthNotAtMost.new([],  toobig, upper)] === Schema.validate(max, toobig)
      assert [LengthNotBetween.new([], toobig, lower, upper)] === Schema.validate(minmax, toobig)
    end
  end

  property "string" do
    check all {lower, upper, toosmall, toobig, inrange} <- Gen.string_test() do
      min = Valet.string(min_len: lower)
      max = Valet.string(max_len: upper)
      minmax = Valet.string(min_len: lower, max_len: upper)
      mins = [min, minmax]
      maxs = [max, minmax]

      for m <- mins, do: assert [] === Schema.validate(m, inrange)
      for m <- maxs, do: assert [] === Schema.validate(m, inrange)
       
      assert [LengthNotAtLeast.new([], toosmall, lower)] === Schema.validate(min, toosmall)
      assert [LengthNotBetween.new([], toosmall, lower, upper)] === Schema.validate(minmax, toosmall)

      assert [LengthNotAtMost.new([],  toobig, upper)] === Schema.validate(max, toobig)
      assert [LengthNotBetween.new([], toobig, lower, upper)] === Schema.validate(minmax, toobig)
    end
  end

  # property "tuple" do
  #   check all lower <- SD.positive_integer(),
  #             count <- SD.positive_integer() do
  #     upper = count + lower
  #   end
  # end

  # TODO: test schema works too
  property "list" do
    check all {lower, upper, toosmall, toobig, inrange} <- Gen.list_test() do
      min = Valet.list(min_len: lower)
      max = Valet.list(max_len: upper)
      minmax = Valet.list(min_len: lower, max_len: upper)
      mins = [min, minmax]
      maxs = [max, minmax]

      for m <- mins, do: assert [] === Schema.validate(m, inrange)
      for m <- maxs, do: assert [] === Schema.validate(m, inrange)
       
      assert [LengthNotAtLeast.new([], toosmall, lower)] === Schema.validate(min, toosmall)
      assert [LengthNotBetween.new([], toosmall, lower, upper)] === Schema.validate(minmax, toosmall)

      assert [LengthNotAtMost.new([],  toobig, upper)] === Schema.validate(max, toobig)
      assert [LengthNotBetween.new([], toobig, lower, upper)] === Schema.validate(minmax, toobig)
    end
  end

  # TODO: test schemata work too
  property "map" do
    check all {lower, upper, toosmall, toobig, inrange} <- Gen.map_test() do
      min = Valet.map(min_len: lower)
      max = Valet.map(max_len: upper)
      minmax = Valet.map(min_len: lower, max_len: upper)
      mins = [min, minmax]
      maxs = [max, minmax]

      for m <- mins, do: assert [] === Schema.validate(m, inrange)
      for m <- maxs, do: assert [] === Schema.validate(m, inrange)
       
      assert [LengthNotAtLeast.new([], toosmall, lower)] === Schema.validate(min, toosmall)
      assert [LengthNotBetween.new([], toosmall, lower, upper)] === Schema.validate(minmax, toosmall)

      assert [LengthNotAtMost.new([],  toobig, upper)] === Schema.validate(max, toobig)
      assert [LengthNotBetween.new([], toobig, lower, upper)] === Schema.validate(minmax, toobig)
    end
  end

  # property "every" do
  # end
  # property "choice" do
  # end
  # property "union" do
  # end

end
