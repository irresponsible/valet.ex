defmodule Valet.Struct do
  @enforce_keys [:required, :optional, :extra, :pre, :post]
  defstruct @enforce_keys
end

import ProtocolEx
alias Valet.Schema
alias Polylens.Lenses
alias Valet.Error.{KeyIsMissing, KeysUnknown, TypeMismatch}

defimpl_ex ValetStruct, %Valet.Struct{}, for: Schema do
  import Valet.Shared, only: [post: 3]

  def validate(_, val, trail) when not(is_map(val)), do: [TypeMismatch.new(trail, val, :map)]
  def validate(%Valet.Struct{required: required, optional: optional, extra: extra}=s, val, trail) do
    ret = required(required, val, trail)
    ++ optional(optional, val, trail)
    ++ extra(required, optional, extra, val, trail)
    post(s, val, ret)
  end

  defp extra(required, optional, extra, val, trail)
  defp extra(_, _, true, _, _), do: []
  defp extra(required, optional, _, val, trail) do
    known = MapSet.new(required ++ optional, &Map.keys/1)
    provided = MapSet.new(Map.keys(val))
    unknown = MapSet.difference(provided, known)
    if Enum.empty?(unknown),
      do: [],
      else: [KeysUnknown.new(trail, val, MapSet.to_list(unknown), MapSet.to_list(known))]
  end

  defp required(nil, _, _), do: []
  defp required(required, val, trail) do
    Enum.flat_map(required, fn {key, s} ->
      if Map.has_key?(val, key),
        do: Schema.validate(s, val[key], [Lenses.at_key(key) | trail]),
        else: [KeyIsMissing.new([Lenses.key_at(key) | trail], val, key, s)]
    end)
  end

  defp optional(nil, _, _), do: []
  defp optional(optional, val, trail) do
    Enum.flat_map(optional, fn {key, s} ->
      if Map.has_key?(val, key),
        do: Schema.validate(s, val[key], [Lenses.at_key(key) | trail]),
        else: []
    end)
  end

end
