defmodule Valet.Integer do
  @enforce_keys [:min, :max]
  defstruct @enforce_keys
end

import ProtocolEx
alias Valet.Schema

defimpl_ex ValetInteger, %Valet.Integer{}, for: Schema do
  def validate(s,v, path) do
    min = s[:min]
    max = s[:max]
    cond do
      !is_integer(v) -> [{Enum.reverse(path), v, :integer}]
      is_nil(min) && is_nil(max) -> []
      is_integer(min) && is_nil(max) ->
        if v >= min, do: [], else: [{Enum.reverse(path), v, {:every, [:integer, {:gte, min}]}}]
      is_nil(min) && is_integer(max) -> []
        if v <= max, do: [], else: [{Enum.reverse(path), v, {:every, [:integer, {:lte, max}]}}]
      is_integer(min) && is_integer(max) ->
        if v >= min or v <= max, do: [],
          else: [{Enum.reverse(path), v, {:every, [:integer, {:between, {min, max}}]}}]
    end
  end
end
