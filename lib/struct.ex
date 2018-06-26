defmodule Valet.Struct do
  @enforce_keys [:required, :optional]
  defstruct @enforce_keys
end

import ProtocolEx
alias Valet.Schema

defimpl_ex ValetStruct, %Valet.Struct{}, for: Schema do
  def validate(_, v, path) when not(is_map(v)), do: [Valet.error(path, v, :map)]
  def validate(%Valet.Struct{required: required, optional: optional}, v, path) do
    Enum.flat_map(required, fn {k, s} ->
      if Map.has_key?(v, k),
        do: Schema.validate(s, v[k], [1, k | path]),
        else: [Valet.error([0, k | path], k, :missing)]
    end) ++ Enum.flat_map(optional, fn {k, s} ->
      if Map.has_key?(v, k),
        do: Schema.validate(s, v[k], [1, k | path]),
        else: []
    end)
  end
end
