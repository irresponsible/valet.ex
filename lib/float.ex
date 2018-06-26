defmodule Valet.Float do
  @enforce_keys [:min, :max]
  defstruct @enforce_keys
end

import ProtocolEx
alias Valet.Schema

defimpl_ex ValetFloat, %Valet.Float{}, for: Schema do
  def validate(_, v, path) when not is_float(v), do: [Valet.error(path, v, :float)]
  def validate(%Valet.Float{min: min, max: max}, v, path) do
    cond do
      is_nil(min) && is_nil(max) -> []
      is_number(min) && is_nil(max) ->
        if v >= min, do: [], else: [Valet.error(path, v, {:gte, min})]
      is_nil(min) && is_number(max) -> []
        if v <= max, do: [], else: [Valet.error(path, v, {:lte, max})]
      is_number(min) && is_number(max) ->
        if v >= min and v <= max, do: [],
          else: [Valet.error(path, v, {:between, {min, max}})]
    end
  end
end
