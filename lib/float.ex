defmodule Valet.Float do
  @enforce_keys [:min, :max, :pre, :post]
  defstruct @enforce_keys
end

import ProtocolEx
alias Valet.Schema

alias Valet.Error.{TypeMismatch, NotAtLeast, NotAtMost, NotBetween}

defimpl_ex ValetFloat, %Valet.Float{}, for: Schema do
  import Valet.Shared, only: [pre: 2, post: 3]

  def validate(_, val, trail) when not is_float(val), do: [TypeMismatch.new(trail, val, :float)]
  def validate(%Valet.Float{min: min, max: max}=f, val, trail) do
    val = pre(f, val)
    post(f, val, sizes(min, max, val, trail))
  end
  defp sizes(nil, nil, _, _), do: []
  defp sizes(min, nil, val, trail) when is_number(min), do: at_least(min, val, trail)
  defp sizes(nil, max, val, trail) when is_number(max), do: at_most(max, val, trail)
  defp sizes(min, max, val, trail) when is_number(min) and is_number(max), do: between(min, max, val, trail)

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

