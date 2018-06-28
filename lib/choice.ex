defmodule Valet.Choice do
  @enforce_keys [:choices]
  defstruct @enforce_keys
end

import ProtocolEx
alias Valet.Schema
alias Valet.Error.NotInSet

defimpl_ex ValetChoice, %Valet.Choice{}, for: Schema do
  def validate(%Valet.Choice{choices: choices}, v, trail) do
    if Enum.member?(choices, v), do: [], else: [NotInSet.new(trail, v, choices)]
  end
end
