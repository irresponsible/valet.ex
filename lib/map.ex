defmodule Valet.Map do
  @enforce_keys [:min_len, :max_len, :key_schema, :val_schema]
  defstruct @enforce_keys
end

import ProtocolEx
alias Valet.Schema

defimpl_ex ValetMap, %Valet.Map{}, for: Schema do
  def validate(_, v, path) when not(is_map(v)), do: Valet.error(path, v, :map)
  def validate(%Valet.Map{key_schema: ks, val_schema: vs, min_len: min, max_len: max}, v, path) do
    r1 = case {min, max} do
      {nil, nil} -> []
      {nil, max} when is_integer(max) ->
        if max >= Enum.count(v), do: [], else: [Valet.error(path, v, {:len_lte, max})]
      {min, nil} when is_integer(min) ->
        if min <= Enum.count(v), do: [], else: [Valet.error(path, v, {:len_gte, min})]
      {min, max} when is_integer(min) and is_integer(max) ->
        len = Enum.count(v)
        if min <= len and max >= len, do: [],
          else: [Valet.error(path, v, {:len_between, {min, max}})]
    end
    r2 = case {ks, vs} do
      {nil,nil} -> []
      {_,nil} ->
        Map.to_list(v)
        |> Enum.flat_map(fn {k,_} -> Schema.validate(ks, k, [0, k | path]) end)
      {nil,_} ->
        Map.to_list(v)
        |> Enum.flat_map(fn {k,v} -> Schema.validate(vs, v, [0, k | path]) end)
      {_,_} ->
        Map.to_list(v)
        |> Enum.flat_map(fn {k,v} ->
              Schema.validate(ks, k, [0, k | path])
           ++ Schema.validate(vs, v, [1, k | path])
        end)
    end
    r1 ++ r2
  end
end
