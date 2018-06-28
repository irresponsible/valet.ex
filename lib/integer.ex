defmodule Valet.Integer do
  @enforce_keys [:min, :max]
  defstruct @enforce_keys
end

import ProtocolEx
alias Valet.Schema
alias Valet.Error.{TypeMismatch, NotAtLeast, NotAtMost, NotBetween}

defimpl_ex ValetInteger, %Valet.Integer{}, for: Schema do
  def validate(_, val, trail) when not is_integer(val), do: [TypeMismatch.new(trail, val, :integer)]
  def validate(%Valet.Integer{min: min, max: max}, val, trail), do: sizes(min, max, val, trail)

  defp sizes(nil, nil, _, _), do: []
  defp sizes(min, nil, val, trail) when is_integer(min), do: at_least(min, val, trail)
  defp sizes(nil, max, val, trail) when is_integer(max), do: at_most(max, val, trail)
  defp sizes(min, max, val, trail) when is_integer(min) and is_integer(max), do: between(min, max, val, trail)

  defp at_least(min, val, trail) do
    if val >= min,
      do: [],
      else: [ NotAtLeast.new(trail, val, min) ]
  end

  defp at_most(max, val, trail) do
    if val <= max,
      do: [],
      else: [ NotAtMost.new(trail, val, max) ]
  end

  defp between(min, max, val, trail) do
    if val >= min && val <= max,
      do: [],
      else: [ NotBetween.new(trail, val, min, max) ]
  end


end
