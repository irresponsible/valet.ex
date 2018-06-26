defmodule Valet.Float do
  @enforce_keys [:min, :max]
  defstruct @enforce_keys
end

import ProtocolEx
alias Valet.Schema

defimpl_ex ValetFloat, %Valet.Float{}, for: Schema do
  def validate(s,v, path) do
    min = s[:min]
    max = s[:max]
    cond do
      !is_number(v) -> [{Enum.reverse(path), v, :float}]
      is_nil(min) && is_nil(max) -> []
      is_number(min) && is_nil(max) ->
        if v >= min, do: [], else: [{Enum.reverse(path), v, {:every, [:float, {:gte, min}]}}]
      is_nil(min) && is_number(max) -> []
        if v <= max, do: [], else: [{Enum.reverse(path), v, {:every, [:float, {:lte, max}]}}]
      is_number(min) && is_number(max) ->
        if v >= min and v <= max, do: [],
          else: [{Enum.reverse(path), v, {:every, [:float, {:between, {min, max}}]}}]
    end
  end
end
