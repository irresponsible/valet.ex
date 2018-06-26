defmodule Valet.Map do
  @enforce_keys [:min_len, :max_len, :key_schema, :val_schema]
  defstruct @enforce_keys
end

import ProtocolEx
alias Valet.Schema

defimpl_ex ValetMap, %Valet.Map{}, for: Schema do
  def validate(_, v, path) when not(is_map(v)), do: [{path, v, :map}]
  def validate(s, v, path) do
    if !is_map(v) do
      [{path, v, :map}]
    end
    ks = s.key_schema
    vs = s.val_schema
    Map.to_list(v)
    |> Enum.flat_map(fn {k,v} -> Schema.validate(ks, k, path) ++ Schema.validate(vs, v, path) end)
  end
end
