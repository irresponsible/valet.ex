defmodule Valet.Binary do
  @enforce_keys [:min_len, :max_len, :regex, :pre, :post]
  defstruct @enforce_keys
end

import ProtocolEx
alias Valet.Schema
alias Polylens.Lenses
alias Valet.Error.{TypeMismatch, RegexDoesNotMatch, LengthNotAtLeast, LengthNotAtMost, LengthNotBetween}

defimpl_ex ValetBinary, %Valet.Binary{}, for: Schema do
  import Valet.Shared, only: [pre: 2, post: 3]

  def validate(_, val, trail) when not is_binary(val), do: [TypeMismatch.new(trail, val, :binary)]
  def validate(%Valet.Binary{min_len: min, max_len: max, regex: regex}=b, val, trail) do
    val = pre(b, val)
    post(b, val, sizes(min, max, val, trail) ++ regex(regex, val, trail))
  end
  defp sizes(nil, nil, _, _), do: []
  defp sizes(min, nil, val, trail) when is_integer(min), do: at_least(min, val, trail)
  defp sizes(nil, max, val, trail) when is_integer(max), do: at_most(max, val, trail)
  defp sizes(min, max, val, trail) when is_integer(min) and is_integer(max), do: between(min, max, val, trail)

  defp regex(nil, _, _), do: []
  defp regex(%Regex{source: source}=regex, val, trail) do
    if val =~ regex,
      do: [],
      else: [RegexDoesNotMatch.new(trail, val, source)]
  end

  defp at_least(min, val, trail) do
    if byte_size(val) >= min,
      do: [],
      else: [ LengthNotAtLeast.new(trail, val, min) ]
  end

  defp at_most(max, val, trail) do
    if byte_size(val) <= max,
      do: [],
      else: [ LengthNotAtMost.new(trail, val, max) ]
  end

  defp between(min, max, val, trail) do
    len = byte_size(val)
    if len >= min && len <= max,
      do: [],
      else: [ LengthNotBetween.new(trail, val, min, max) ]
  end
  
end
