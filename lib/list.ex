defmodule Valet.List do
  @enforce_keys [:min_len, :max_len, :schema]
  defstruct @enforce_keys
end

import ProtocolEx
alias Polylens.Lenses
alias Valet.Schema
alias Valet.Error.{LengthNotAtLeast,LengthNotAtMost, LengthNotBetween, TypeMismatch}

defimpl_ex ValetList, %Valet.List{}, for: Schema do
  def validate(_, val, trail) when not is_list(val), do: [TypeMismatch.new(trail, val, :list)]
  def validate(%Valet.List{min_len: min, max_len: max, schema: schema}, val, trail) when is_list(val),
    do: sizes(min, max, val, trail) ++ schema(schema, val, trail)

  defp sizes(min, max, val, trail)
  defp sizes(nil, nil, _, _), do: []
  defp sizes(min, nil, val, trail) when is_integer(min), do: at_least(min, val, trail)
  defp sizes(nil, max, val, trail) when is_integer(max), do: at_most(max, val, trail)
  defp sizes(min, max, val, trail) when is_integer(min) and is_integer(max), do: between(min, max, val, trail)

  defp schema(nil, _, _), do: []
  defp schema(schema, val, trail) do
    Enum.with_index(val)
    |> Enum.flat_map(fn {v,i} -> Schema.validate(schema, v, [Lenses.at_index(i) | trail]) end)
  end

  defp at_least(min, val, trail) do
    if Enum.count(val) >= min,
      do: [],
      else: [ LengthNotAtLeast.new(trail, val, min) ]
  end

  defp at_most(max, val, trail) do
    if Enum.count(val) <= max,
      do: [],
      else: [ LengthNotAtMost.new(trail, val, max) ]
  end

  defp between(min, max, val, trail) do
    len = Enum.count(val)
    if len >= min && len <= max,
      do: [],
      else: [ LengthNotBetween.new(trail, val, min, max) ]
  end

end
