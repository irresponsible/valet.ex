defmodule Valet.List do
  @enforce_keys [:min_len, :max_len, :schema]
  defstruct @enforce_keys
end

import ProtocolEx
alias Valet.Schema

defimpl_ex ValetList, %Valet.List{}, for: Schema do
  def validate(_,v, path) when not(is_list(v)), do: [{path, v, :expected_list}]
  def validate(s,v, path) when is_list(v) do
    lower = s.min_len
    upper = s.max_len
    schema = s.schema
    r1 = cond do
      is_nil(lower) && is_nil(upper) -> []
      is_integer(lower) && is_nil(upper) ->
        if byte_size(v) >= lower, do: [],
          else: [{Enum.reverse(path), v, {:every, [:list, {:len_gte, lower}]}}]
      is_nil(lower) && is_integer(upper) ->
        if byte_size(v) <= upper, do: [],
          else: [{Enum.reverse(path), v, {:every, [:list, {:len_lte, upper}]}}]
      is_integer(lower) && is_integer(upper) ->
        len = byte_size(v)
        if len >= lower and len <= upper, do: [],
          else: [{Enum.reverse(path), v, {:every, [:list, {:len_between, {lower, upper}}]}}]
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
