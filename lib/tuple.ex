defmodule Valet.Tuple do
  @enforce_keys [:schemata, :pre, :post]
  defstruct @enforce_keys
end

import ProtocolEx
alias Valet.Schema
alias Valet.Error.{TypeMismatch, LengthNot}

defimpl_ex ValetTuple, %Valet.Tuple{}, for: Schema do
  import Valet.Shared, only: [pre: 2, post: 3]
  alias Polylens.Lenses

  def validate(_, v, trail) when not is_tuple(v), do: {:error, [TypeMismatch.new(trail, v, :tuple)]}
  def validate(%Valet.Tuple{schemata: schemata}, v, trail)
  when tuple_size(schemata) !== tuple_size(v), do: {:error, [LengthNot.new(trail, v, tuple_size(schemata))]}
  def validate(%Valet.Tuple{schemata: schemata}=t, v, trail) do
    val = pre(t, v)
    {vals, errs, _} = Enum.zip(Tuple.to_list(schemata), Tuple.to_list(val))
    |> Enum.reduce({[],[],0}, fn {s,v}, {rs,es,idx} ->
      case Schema.validate(s,v, [Lenses.at_index(idx) | trail]) do
	{:ok, val} -> {[val | rs], es, idx + 1}
	{:error, es2} -> {[], es2 ++ es, idx + 1}
      end
    end)
    case errs do
      [] -> post(t, List.to_tuple(Enum.reverse(vals)), [])
      _ -> {:error, errs}
    end
  end
end
