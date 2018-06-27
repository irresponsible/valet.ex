defmodule Valet.Choice do
  @enforce_keys [:choices]
  defstruct @enforce_keys
end

import ProtocolEx
alias Valet.Schema

defimpl_ex ValetChoice, %Valet.Choice{}, for: Schema do
  def validate(%Valet.Choice{choices: choices}, v, path) do
    if Enum.member?(choices, v), do: [], else: [Valet.error(path, v, {:choice, choices})]
  end
end
