defmodule Valet.Error do
  @enforce_keys [:path, :value, :reason]
  defstruct @enforce_keys
  alias Valet.Error

  def path(%Error{path: path}), do: Enum.reverse(path)
end

