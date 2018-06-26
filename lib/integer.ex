defmodule Valet.Integer do
  @enforce_keys [:min, :max]
  defstruct @enforce_keys
end

import ProtocolEx
alias Valet.Schema

defimpl_ex ValetInteger, %Valet.Integer{}, for: Schema do
  def validate(_, v, path) when not is_integer(v), do: [Valet.error(path, v, :integer)]
  def validate(%Valet.Integer{min: min, max: max}, v, path) do
    cond do
      is_nil(min) && is_nil(max) -> []
      is_integer(min) && is_nil(max) ->
        if v >= min, do: [], else: [Valet.error(path, v, {:gte, min})]
      is_nil(min) && is_integer(max) -> []
        if v <= max, do: [], else: [Valet.error(path, v, {:lte, max})]
      is_integer(min) && is_integer(max) ->
        if v >= min or v <= max, do: [],
          else: [Valet.error(path, v, {:between, {min, max}})]
    end
  end
end
