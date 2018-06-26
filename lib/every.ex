defmodule Valet.Every do
  @enforce_keys [:schemata]
  defstruct @enforce_keys
end

import ProtocolEx
alias Valet.Schema
alias Valet.Every

defimpl_ex ValetEvery, %Every{}, for: Schema do
  def validate(s,v, path) do
    Enum.flat_map(s.schemata, fn val -> val.(v, path) end)
  end
end