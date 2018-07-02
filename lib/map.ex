defmodule Valet.Map do
  @enforce_keys [:min_len, :max_len, :key_schema, :val_schema, :pre, :post]
  defstruct @enforce_keys
end

import ProtocolEx
alias Polylens.Lenses
alias Valet.Schema
alias Valet.Error.{LengthNotAtLeast,LengthNotAtMost, LengthNotBetween, TypeMismatch}

defimpl_ex ValetMap, %Valet.Map{}, for: Schema do
  import Valet.Shared, only: [pre: 2, post: 3]

  def validate(_, val, trail) when not is_map(val), do: [TypeMismatch.new(trail, val, :map)]
  def validate(%Valet.Map{key_schema: ks, val_schema: vs, min_len: min, max_len: max}=m, val, trail) do
    val = pre(m, val)
    sz = sizes(min, max, val, trail)
    case schemata(ks, vs, val, trail) do
      {:ok, val} -> post(m, val, sz)
      {:error, es} -> post(m, val, es ++ sz)
    end
  end

  defp sizes(min, max, val, trail)
  defp sizes(nil, nil, _, _), do: []
  defp sizes(min, nil, val, trail) when is_integer(min), do: at_least(min, val, trail)
  defp sizes(nil, max, val, trail) when is_integer(max), do: at_most(max, val, trail)
  defp sizes(min, max, val, trail) when is_integer(min) and is_integer(max), do: between(min, max, val, trail)

  defp schemata(key_schema, val_schema, val, trail)
  defp schemata(nil, nil, val, _), do: {:ok, val}
  defp schemata(ks, nil, val, trail) do
    {vals, errs} = Enum.reduce(val, {%{},[]}, fn {k, v}, {vals,errs} ->
      case Schema.validate(ks, k, [Lenses.key_at(k) | trail]) do
	{:ok, k} -> {Map.put(vals, k, v), errs}
	{:error, es} -> {[], es ++ errs}
      end
    end)
    case errs do
      [] -> {:ok, vals}
      _ -> {:error, errs}
    end
  end
  defp schemata(nil, vs, val, trail) do
    {vals, errs} = Enum.reduce(val, {%{},[]}, fn {k, v}, {vals,errs} ->
      case Schema.validate(vs, v, [Lenses.at_key(k) | trail]) do
	{:ok, v} -> {Map.put(vals, k, v), errs}
	{:error, es} -> {[], es ++ errs}
      end
    end)
    case errs do
      [] -> {:ok, vals}
      _ -> {:error, errs}
    end
  end
  defp schemata(ks, vs, val, trail) do
    {vals, errs} = Enum.reduce(val, {%{},[]}, fn {k, v}, {vals,errs} ->
      lk = Lenses.key_at(k)
      lv = Lenses.at_key(k)
      rk = Schema.validate(ks, k, [lk | trail])
      rv = Schema.validate(vs, v, [lv | trail])
      case {rk,rv} do
	{{:ok,k},{:ok,v}} -> {Map.put(vals, k, v), errs}
	{{:ok,_},{:error,v}} -> {%{}, v ++ errs}
	{{:error,k},{:ok,_}} -> {%{}, k ++ errs}
	{{:error,k},{:error,v}} -> {%{}, k ++ v ++ errs}
      end
    end)
    case errs do
      [] -> {:ok, vals}
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
