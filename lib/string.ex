defmodule Valet.String do
  @enforce_keys [:min_len, :max_len, :regex]
  defstruct @enforce_keys
end

import ProtocolEx
alias Valet.Schema

defimpl_ex ValetString, %Valet.String{}, for: Schema do
  def validate(_, v, path) when not is_binary(v), do: [{Enum.reverse(path), v, :binary}]
  def validate(%Valet.String{min_len: min_len, max_len: max_len, regex: regex}, v, path) do
    r1 = cond do
      !is_binary(v) -> [{Enum.reverse(path), v, :string}]
      is_nil(min_len) && is_nil(max_len) -> []
      is_integer(min_len) && is_integer(max_len) ->
        len = String.length(v)
        if len >= min_len and len <= max_len, do: [],
          else: [{Enum.reverse(path), v, {:every, [:string, {:len_between, {min_len, max_len}}]}}]
      is_integer(min_len) && is_nil(max_len) ->
          if String.length(v) >= min_len, do: [],
            else: [{Enum.reverse(path), v, {:every, [:string, {:len_gte, min_len}]}}]
      is_nil(min_len) && is_integer(max_len) ->
        if String.length(v) <= max_len, do: [],
          else: [{Enum.reverse(path), v, {:every, [:string, {:len_lte, max_len}]}}]
    end
    r2 = case regex do
      nil -> []
      %Regex{source: source} ->
        if v =~ regex, do: [], else: [{:every, [:string, {:matches, source}]}]
    end
    r1 ++ r2
  end
  
end
