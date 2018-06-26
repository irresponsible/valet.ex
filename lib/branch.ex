defmodule Valet.Branch do
  @enforce_keys [:branches]
  defstruct @enforce_keys

  alias Valet.Branch

  @doc """
  Picks the first branch for which there are no validation errors
  """
  def pick(%Branch{branches: branches}, data),
    do: Enum.find(branches, fn {k, s} -> [] == Schema.validate(s, data) end)

end

import ProtocolEx
alias Valet.Schema
alias Valet.Branch

defimpl_ex ValetBranch, %Branch{}, for: Schema do
  def validate(s, v, path) do
    Enum.reduce_while(s.branches, [], fn {k, s}, acc ->
      case Schema.validate(s, v, [k | path]) do
        [] -> {:halt, []}
        fail -> {:cont, fail ++ acc}
      end
    end)
  end
end
