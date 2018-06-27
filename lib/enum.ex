defmodule Valet.Enum do
  @enforce_keys [:values]
  defstruct @enforce_keys
end

import ProtocolEx
alias Valet.Schema

defimpl_ex ValetEnum, %Valet.Enum{}, for: Schema do
  def validate(%Valet.Enum{values: values}, v, path) do
    if Enum.member?(values, v), do: [], else: [Valet.error(path, v, {:enum, values})]
  end
end
