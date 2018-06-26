defmodule Valet.Number do
  @enforce_keys [:min, :max]
  defstruct @enforce_keys
end

import ProtocolEx
alias Valet.Schema

defimpl_ex ValetNumber, %Valet.Number{}, for: Schema do
  def validate(s,v, path) do
    min = s[:min]
    max = s[:max]
    cond do
      !is_number(v) -> [{Enum.reverse(path), v, :number}]
      is_nil(min) && is_nil(max) -> []
      is_number(min) && is_nil(max) -> 
        if v >= min, do: [], else: [{Enum.reverse(path), v, {:every, [:number, {:gte, min}]}}]
      is_nil(min) && is_number(max) -> []
        if v <= max, do: [], else: [{Enum.reverse(path), v, {:every, [:number, {:lte, max}]}}]
      is_number(min) && is_number(max) ->
        if v >= min and v <= max, do: [],
          else: [{Enum.reverse(path), v, {:every, [:number, {:between, {min, max}}]}}]
    end
  end
end
