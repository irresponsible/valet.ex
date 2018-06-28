defmodule Valet.Map do
  @enforce_keys [:min_len, :max_len, :key_schema, :val_schema]
  defstruct @enforce_keys
end

import ProtocolEx
alias Polylens.Lenses
alias Valet.Schema
alias Valet.Error.{LengthNotAtLeast,LengthNotAtMost, LengthNotBetween, TypeMismatch}

defimpl_ex ValetMap, %Valet.Map{}, for: Schema do
  def validate(_, val, trail) when not is_map(val), do: [TypeMismatch.new(trail, val, :map)]
  def validate(%Valet.Map{key_schema: ks, val_schema: vs, min_len: min, max_len: max}, val, trail),
    do: sizes(min, max, val, trail) ++ schemata(ks, vs, val, trail)

  defp sizes(min, max, val, trail)
  defp sizes(nil, nil, _, _), do: []
  defp sizes(min, nil, val, trail) when is_integer(min), do: at_least(min, val, trail)
  defp sizes(nil, max, val, trail) when is_integer(max), do: at_most(max, val, trail)
  defp sizes(min, max, val, trail) when is_integer(min) and is_integer(max), do: between(min, max, val, trail)

  defp schemata(key_schema, val_schema, val, trail)
  defp schemata(nil, nil, _, _), do: []
  defp schemata(ks, nil, val, trail) do
    Enum.flat_map(val, fn {k,_} -> Schema.validate(ks, k, [Lenses.key_at(k) | trail]) end)
  end
  defp schemata(nil, vs, val, trail) do
    Enum.flat_map(val, fn {k,v} -> Schema.validate(vs, v, [Lenses.at_key(k)| trail]) end)
  end
  defp schema(schema, val, trail) do
    Enum.flat_map(val, fn {k,v} ->
      lk = Lenses.key_at(k)
      lv = Lenses.at_key(k)
      Schema.validate(ks, k, [lk | trail]) ++ Schema.validate(vs, v, [lv | trail])
    end)
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
