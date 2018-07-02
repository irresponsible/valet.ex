defmodule Valet.Union do
  @enforce_keys [:branches, :pre, :post]
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
  import Valet.Shared, only: [post: 3]

  def validate(s, v, trail) do
    ret = Enum.reduce_while(s.branches, [], fn {k, s}, acc ->
      case Schema.validate(s, v, [k | trail]) do
        {:ok, val} -> {:halt, {:ok, val}}
        {:error, fail} -> {:cont, [{k, fail} | acc]}
      end
    end)
    case ret do
      {:ok, val} -> post(s, val, [])
      errors -> {:error, [Valet.Error.Disunion.new(trail, v, errors)]}
    end
  end
end
