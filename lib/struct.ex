defmodule Valet.Struct do
  @enforce_keys [:required, :optional, :extra, :pre, :post]
  defstruct @enforce_keys
end

import ProtocolEx
alias Valet.Schema
alias Polylens.Lenses
alias Valet.Error.{KeyIsMissing, KeysUnknown, TypeMismatch}

defimpl_ex ValetStruct, %Valet.Struct{}, for: Schema do
  import Valet.Shared, only: [pre: 2, post: 3]

  def validate(_, val, trail) when not(is_map(val)), do: [TypeMismatch.new(trail, val, :map)]
  def validate(%Valet.Struct{required: required, optional: optional, extra: extra}=s, val, trail) do
    val = pre(s, val)
    extra = extra(required, optional, extra, val, trail)
    case required(required, val, trail) do
      {:ok, val} ->
	case optional(optional, val, trail) do
	  {:ok, val} -> post(s, val, extra)
	  {:error, errs} -> {:error, errs ++ extra}
	end
      {:error, errs} ->
	case optional(optional, val, trail) do
	  {:ok, _} -> {:error, errs ++ extra}
	  {:error, errs2} -> {:error, errs ++ errs2 ++ extra}
	end
    end
  end

  defp extra(required, optional, extra, val, trail)
  defp extra(_, _, true, _, _), do: []
  defp extra(required, optional, _, val, trail) do
    keys = case {required, optional} do
      {nil, nil} -> []
      {%{}, nil} -> Map.keys(required)
      {nil, %{}} -> Map.keys(optional)
      {%{},%{}} -> Map.keys(required) ++ Map.keys(optional)
    end
    known = MapSet.new(keys)
    provided = MapSet.new(Map.keys(val))
    unknown = MapSet.difference(provided, known)
    if Enum.empty?(unknown),
      do: [],
      else: [KeysUnknown.new(trail, val, MapSet.to_list(unknown), MapSet.to_list(known))]
  end

  defp required(nil, val, _), do: {:ok, val}
  defp required(required, val, trail) do
    {ret, errs} = Enum.reduce(required, {val,[]}, fn {key,schema}, {vals, errs} ->
      if Map.has_key?(val, key) do
	case Schema.validate(schema, val[key], [Lenses.at_key(key) | trail]) do
	  {:ok, val} -> {Map.put(vals, key, val), errs}
	  {:error, es} -> {%{}, es ++ errs}
	end
      else
	{%{}, [KeyIsMissing.new([Lenses.key_at(key) | trail], val, key, schema)] ++ errs}
      end
    end)
    case errs do
      [] -> {:ok, ret}
      _ -> {:error, errs}
    end
  end

  defp optional(nil, val, _), do: {:ok, val}
  defp optional(optional, val, trail) do
    {ret, errs} = Enum.reduce(optional, {val,[]}, fn {key,schema}, {vals, errs} ->
      if Map.has_key?(val, key) do
	case Schema.validate(schema, val[key], [Lenses.at_key(key) | trail]) do
	  {:ok, val} -> {Map.put(vals, key, val), errs}
	  {:error, es} -> {%{}, es ++ errs}
	end
      else
	{Map.put(vals, key, val[key]), errs}
      end
    end)
    case errs do
      [] -> {:ok, ret}
      _ -> {:error, errs}
    end
  end

end
