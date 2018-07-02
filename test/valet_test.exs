defmodule ValetTest do
  use ExUnit.Case
  use ExUnitProperties
  alias Valet.Schema
  # alias StreamData, as: SD
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

  # todo: test pre/post
  property "integer" do
    check all {lower, upper, toosmall, toobig, inrange} <- Gen.int_test() do
      min = Valet.integer(min: lower)
      max = Valet.integer(max: upper)
      minmax = Valet.integer(min: lower, max: upper)
      mins = [min, minmax]
      maxs = [max, minmax]

      for m <- mins, do: assert {:ok, inrange} === Schema.validate(m, inrange)
      for m <- maxs, do: assert {:ok, inrange} === Schema.validate(m, inrange)
       
      assert {:error, [NotAtLeast.new([], toosmall, lower)]} === Schema.validate(min, toosmall)
      assert {:error, [NotBetween.new([], toosmall, lower, upper)]} === Schema.validate(minmax, toosmall)

      assert {:error, [NotAtMost.new([],  toobig, upper)]} === Schema.validate(max, toobig)
      assert {:error, [NotBetween.new([], toobig, lower, upper)]} === Schema.validate(minmax, toobig)
    end
  end

  # What is all this funky casting of integer about, you ask? perhaps
  # predictably, stream_data picked something that would overflow
  # fairly quickly with float()
  # todo: test pre/post
  property "float" do
    check all {lower, upper, toosmall, toobig, inrange} <- Gen.float_test() do

      min = Valet.float(min: lower)
      max = Valet.float(max: upper)
      minmax = Valet.float(min: lower, max: upper)
      mins = [min, minmax]
      maxs = [max, minmax]

      for m <- mins, do: assert {:ok, inrange} === Schema.validate(m, inrange)
      for m <- maxs, do: assert {:ok, inrange} === Schema.validate(m, inrange)
       
      assert {:error, [NotAtLeast.new([], toosmall, lower)]} === Schema.validate(min, toosmall)
      assert {:error, [NotBetween.new([], toosmall, lower, upper)]} === Schema.validate(minmax, toosmall)
      assert {:error, [NotAtMost.new([],  toobig, upper)]} === Schema.validate(max, toobig)
      assert {:error, [NotBetween.new([], toobig, lower, upper)]} === Schema.validate(minmax, toobig)
    end
  end

  # todo: test pre/post
  property "number - int" do
    check all {lower, upper, toosmall, toobig, inrange} <- Gen.int_test() do

      min = Valet.number(min: lower)
      max = Valet.number(max: upper)
      minmax = Valet.number(min: lower, max: upper)
      mins = [min, minmax]
      maxs = [max, minmax]

      for m <- mins, do: assert {:ok, inrange} === Schema.validate(m, inrange)
      for m <- maxs, do: assert {:ok, inrange} === Schema.validate(m, inrange)
       
      assert {:error, [NotAtLeast.new([], toosmall, lower)]} === Schema.validate(min, toosmall)
      assert {:error, [NotBetween.new([], toosmall, lower, upper)]} === Schema.validate(minmax, toosmall)
      assert {:error, [NotAtMost.new([],  toobig, upper)]} === Schema.validate(max, toobig)
      assert {:error, [NotBetween.new([], toobig, lower, upper)]} === Schema.validate(minmax, toobig)
    end
  end

  # todo: test pre/post
  property "number - float" do
    check all {lower, upper, toosmall, toobig, inrange} <- Gen.float_test() do

      min = Valet.number(min: lower)
      max = Valet.number(max: upper)
      minmax = Valet.number(min: lower, max: upper)
      mins = [min, minmax]
      maxs = [max, minmax]

      for m <- mins, do: assert {:ok, inrange} === Schema.validate(m, inrange)
      for m <- maxs, do: assert {:ok, inrange} === Schema.validate(m, inrange)
       
      assert {:error, [NotAtLeast.new([], toosmall, lower)]} === Schema.validate(min, toosmall)
      assert {:error, [NotBetween.new([], toosmall, lower, upper)]} === Schema.validate(minmax, toosmall)
      assert {:error, [NotAtMost.new([],  toobig, upper)]} === Schema.validate(max, toobig)
      assert {:error, [NotBetween.new([], toobig, lower, upper)]} === Schema.validate(minmax, toobig)
    end
  end

  # todo: test pre/post
  property "binary" do
    check all {lower, upper, toosmall, toobig, inrange} <- Gen.binary_test() do
      min = Valet.binary(min_len: lower)
      max = Valet.binary(max_len: upper)
      minmax = Valet.binary(min_len: lower, max_len: upper)
      mins = [min, minmax]
      maxs = [max, minmax]

      for m <- mins, do: assert {:ok, inrange} === Schema.validate(m, inrange)
      for m <- maxs, do: assert {:ok, inrange} === Schema.validate(m, inrange)
       
      assert {:error, [LengthNotAtLeast.new([], toosmall, lower)]} === Schema.validate(min, toosmall)
      assert {:error, [LengthNotBetween.new([], toosmall, lower, upper)]} === Schema.validate(minmax, toosmall)
      assert {:error, [LengthNotAtMost.new([],  toobig, upper)]} === Schema.validate(max, toobig)
      assert {:error, [LengthNotBetween.new([], toobig, lower, upper)]} === Schema.validate(minmax, toobig)
    end
  end

  # todo: test pre/post
  property "string" do
    check all {lower, upper, toosmall, toobig, inrange} <- Gen.string_test() do
      min = Valet.string(min_len: lower)
      max = Valet.string(max_len: upper)
      minmax = Valet.string(min_len: lower, max_len: upper)
      mins = [min, minmax]
      maxs = [max, minmax]

      for m <- mins, do: assert {:ok, inrange} === Schema.validate(m, inrange)
      for m <- maxs, do: assert {:ok, inrange} === Schema.validate(m, inrange)
       
      assert {:error, [LengthNotAtLeast.new([], toosmall, lower)]} === Schema.validate(min, toosmall)
      assert {:error, [LengthNotBetween.new([], toosmall, lower, upper)]} === Schema.validate(minmax, toosmall)
      assert {:error, [LengthNotAtMost.new([],  toobig, upper)]} === Schema.validate(max, toobig)
      assert {:error, [LengthNotBetween.new([], toobig, lower, upper)]} === Schema.validate(minmax, toobig)
    end
  end

  # todo: test pre/post
  # property "tuple" do
  #   check all lower <- SD.positive_integer(),
  #             count <- SD.positive_integer() do
  #     upper = count + lower
  #   end
  # end

  # TODO: test schema works too
  # todo: test pre/post
  property "list" do
    check all {lower, upper, toosmall, toobig, inrange} <- Gen.list_test() do
      min = Valet.list(min_len: lower)
      max = Valet.list(max_len: upper)
      minmax = Valet.list(min_len: lower, max_len: upper)
      mins = [min, minmax]
      maxs = [max, minmax]

      for m <- mins, do: assert {:ok, inrange} === Schema.validate(m, inrange)
      for m <- maxs, do: assert {:ok, inrange} === Schema.validate(m, inrange)
       
      assert {:error, [LengthNotAtLeast.new([], toosmall, lower)]} === Schema.validate(min, toosmall)
      assert {:error, [LengthNotBetween.new([], toosmall, lower, upper)]} === Schema.validate(minmax, toosmall)
      assert {:error, [LengthNotAtMost.new([],  toobig, upper)]} === Schema.validate(max, toobig)
      assert {:error, [LengthNotBetween.new([], toobig, lower, upper)]} === Schema.validate(minmax, toobig)
    end
  end

  # TODO: test schemata work too
  # todo: test pre/post
  property "map" do
    check all {lower, upper, toosmall, toobig, inrange} <- Gen.map_test() do
      min = Valet.map(min_len: lower)
      max = Valet.map(max_len: upper)
      minmax = Valet.map(min_len: lower, max_len: upper)
      mins = [min, minmax]
      maxs = [max, minmax]

      for m <- mins, do: assert {:ok, inrange} === Schema.validate(m, inrange)
      for m <- maxs, do: assert {:ok, inrange} === Schema.validate(m, inrange)
       
      assert {:error, [LengthNotAtLeast.new([], toosmall, lower)]} === Schema.validate(min, toosmall)
      assert {:error, [LengthNotBetween.new([], toosmall, lower, upper)]} === Schema.validate(minmax, toosmall)
      assert {:error, [LengthNotAtMost.new([],  toobig, upper)]} === Schema.validate(max, toobig)
      assert {:error, [LengthNotBetween.new([], toobig, lower, upper)]} === Schema.validate(minmax, toobig)
    end
  end

  # todo: test pre/post
  # property "every" do
  # end

  # todo: test pre/post
  # property "choice" do
  # end

  # todo: test pre/post
  # property "union" do
  # end

end
