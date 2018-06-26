defmodule Valet.List do
  @enforce_keys [:min_len, :max_len, :schema]
  defstruct @enforce_keys
end

import ProtocolEx
alias Valet.Schema

defimpl_ex ValetList, %Valet.List{}, for: Schema do
  def validate(_,v, path) when not(is_list(v)), do: [Valet.error(path, v, :list)]
  def validate(%Valet.List{min_len: min, max_len: max, schema: schema}, v, path) when is_list(v) do
    r1 = cond do
      is_nil(min) && is_nil(max) -> []
      is_integer(min) && is_nil(max) ->
        if byte_size(v) >= min, do: [],
          else: [Valet.error(path, v, {:len_gte, min})]
      is_nil(min) && is_integer(max) ->
        if byte_size(v) <= max, do: [],
          else: [Valet.error(path, v, {:len_lte, max})]
      is_integer(min) && is_integer(max) ->
        len = byte_size(v)
        if len >= min and len <= max, do: [],
          else: [Valet.error(path, v, {:len_between, {min, max}})]
    end
    r2 = case schema do
      nil -> []
      _ ->
        Enum.with_index(v)
        |> Enum.flat_map(fn {v,i} -> Schema.validate(schema, v, [i | path]) end)
    end
    r1 ++ r2
  end
end
