defmodule Valet.Binary do
  @enforce_keys [:min_len, :max_len, :regex]
  defstruct @enforce_keys
end

import ProtocolEx
alias Valet.Schema

defimpl_ex ValetBinary, %Valet.Binary{}, for: Schema do
  def validate(_, v, path) when not is_binary(v), do: [Valet.error(path, v, :binary)]
  def validate(%Valet.Binary{min_len: min_len, max_len: max_len, regex: regex}, v, path) do
    r1 = cond do
      is_nil(min_len) && is_nil(max_len) -> []
      is_integer(min_len) && is_nil(max_len) ->
        if byte_size(v) >= min_len, do: [],
          else: [Valet.error(path, v, {:len_gte, min_len})]
      is_nil(min_len) && is_integer(max_len) -> []
        if byte_size(v) <= max_len, do: [],
          else: [Valet.error(path, v, {:len_lte, max_len})]
      is_integer(min_len) && is_integer(max_len) ->
        len = byte_size(v)
        if len >= min_len and len <= max_len, do: [],
          else: [Valet.error(path, v, {:len_between, {min_len, max_len}})]
    end
    r2 = case regex do
      nil -> []
      %Regex{source: source} ->
        if v =~ regex, do: [],
          else: [Valet.error(path, v, {:matches, source})]
    end
    r1 ++ r2
  end
end
