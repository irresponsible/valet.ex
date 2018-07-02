defmodule Valet.Choice do
  @enforce_keys [:choices, :pre, :post]
  defstruct @enforce_keys
end

import ProtocolEx
alias Valet.Schema
alias Valet.Error.NotInSet

defimpl_ex ValetChoice, %Valet.Choice{}, for: Schema do
  import Valet.Shared, only: [pre: 2, post: 3]

  def validate(%Valet.Choice{choices: choices}=c, val, trail) do
    val = pre(c, val)
    if Enum.member?(choices, val),
      do: post(c, val, trail),
      else: {:error, [NotInSet.new(trail, val, choices)]}
  end
end
