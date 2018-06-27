defmodule Valet.Union do
  @enforce_keys [:branches]
  defstruct @enforce_keys

  alias Valet.Union

  @doc """
  Picks the first branch for which there are no validation errors
  """
  def pick(%Union{branches: branches}, data),
    do: Enum.find(branches, fn {_, s} -> [] === Schema.validate(s, data) end)

end

import ProtocolEx
alias Valet.Schema
alias Valet.Union

defimpl_ex ValetUnion, %Union{}, for: Schema do
  def validate(s, v, path) do
    Enum.reduce_while(s.branches, [], fn {k, s}, acc ->
      case Schema.validate(s, v, [k | path]) do
        [] -> {:halt, []}
        fail -> {:cont, fail ++ acc}
      end
    end)
  end
end
