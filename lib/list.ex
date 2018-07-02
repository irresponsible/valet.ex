defmodule Valet.List do
  @enforce_keys [:min_len, :max_len, :schema, :pre, :post]
  defstruct @enforce_keys
end

import ProtocolEx
alias Polylens.Lenses
alias Valet.Schema
alias Valet.Error.{LengthNotAtLeast,LengthNotAtMost, LengthNotBetween, TypeMismatch}

defimpl_ex ValetList, %Valet.List{}, for: Schema do
  import Valet.Shared, only: [pre: 2, post: 3]

  def validate(_, val, trail) when not is_list(val), do: {:error, [TypeMismatch.new(trail, val, :list)]}
  def validate(%Valet.List{min_len: min, max_len: max, schema: schema}=l, val, trail) when is_list(val) do
    val = pre(l, val)
    sz = sizes(min, max, val, trail)
    case schema(schema, val, trail) do
      {:ok, vals} -> post(l, vals, sz)
      {:error, es} -> {:error, es ++ sz}
    end
  end

  defp sizes(min, max, val, trail)
  defp sizes(nil, nil, _, _), do: []
  defp sizes(min, nil, val, trail) when is_integer(min), do: at_least(min, val, trail)
  defp sizes(nil, max, val, trail) when is_integer(max), do: at_most(max, val, trail)
  defp sizes(min, max, val, trail) when is_integer(min) and is_integer(max), do: between(min, max, val, trail)

  defp schema(nil, val, _), do: {:ok, val}
  defp schema(schema, val, trail) do
    {vals, errs} = Enum.reduce(val, {[],[]}, fn {val, index}, {vals,errs} ->
      case Schema.validate(schema, val, [Lenses.at_index(index) | trail]) do
	{:ok, v} -> {[v | vals], errs}
	{:error, es} -> {[], es ++ errs}
      end
    end)
    case errs do
      [] -> {:ok, Enum.reverse(vals)}
      _ -> {:error, errs}
    end
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
