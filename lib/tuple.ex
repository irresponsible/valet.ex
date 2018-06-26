defmodule Valet.Tuple do
  @enforce_keys [:schemata]
  defstruct @enforce_keys
end

import ProtocolEx
alias Valet.Schema

defimpl_ex ValetTuple, %Valet.Tuple{}, for: Schema do
  def validate(_, v, path) when not is_tuple(v), do: [Valet.error(path, v, :tuple)]
  def validate(%Valet.Tuple{schemata: schemata}, v, path) do
    case {schemata, v} do
      {{s1, s2},{v1, v2}} ->
           Schema.validate(s1, v1, [ 0 | path])
        ++ Schema.validate(s2, v2, [ 1 | path])
      {{s1, s2, s3},{v1, v2, v3}} ->
           Schema.validate(s1, v1, [ 0 | path])
        ++ Schema.validate(s2, v2, [ 1 | path])
        ++ Schema.validate(s3, v3, [ 2 | path])
      {{s1, s2, s3, s4},{v1, v2, v3, v4}} ->
           Schema.validate(s1, v1, [ 0 | path])
        ++ Schema.validate(s2, v2, [ 1 | path])
        ++ Schema.validate(s3, v3, [ 2 | path])
        ++ Schema.validate(s4, v4, [ 3 | path])
      {{s1, s2, s3, s4, s5},{v1, v2, v3, v4, v5}} ->
           Schema.validate(s1, v1, [ 0 | path])
        ++ Schema.validate(s2, v2, [ 1 | path])
        ++ Schema.validate(s3, v3, [ 2 | path])
        ++ Schema.validate(s4, v4, [ 3 | path])
        ++ Schema.validate(s5, v5, [ 4 | path])
      {{s1, s2, s3, s4, s5, s6},{v1, v2, v3, v4, v5, v6}} ->
           Schema.validate(s1, v1, [ 0 | path])
        ++ Schema.validate(s2, v2, [ 1 | path])
        ++ Schema.validate(s3, v3, [ 2 | path])
        ++ Schema.validate(s4, v4, [ 3 | path])
        ++ Schema.validate(s5, v5, [ 4 | path])
        ++ Schema.validate(s6, v6, [ 5 | path])
      {{s1, s2, s3, s4, s5, s6, s7},{v1, v2, v3, v4, v5, v6, v7}} ->
           Schema.validate(s1, v1, [ 0 | path])
        ++ Schema.validate(s2, v2, [ 1 | path])
        ++ Schema.validate(s3, v3, [ 2 | path])
        ++ Schema.validate(s4, v4, [ 3 | path])
        ++ Schema.validate(s5, v5, [ 4 | path])
        ++ Schema.validate(s6, v6, [ 5 | path])
        ++ Schema.validate(s7, v7, [ 6 | path])
      {{s1, s2, s3, s4, s5, s6, s7, s8},{v1, v2, v3, v4, v5, v6, v7, v8}} ->
           Schema.validate(s1, v1, [ 0 | path])
        ++ Schema.validate(s2, v2, [ 1 | path])
        ++ Schema.validate(s3, v3, [ 2 | path])
        ++ Schema.validate(s4, v4, [ 3 | path])
        ++ Schema.validate(s5, v5, [ 4 | path])
        ++ Schema.validate(s6, v6, [ 5 | path])
        ++ Schema.validate(s7, v7, [ 6 | path])
        ++ Schema.validate(s8, v8, [ 7 | path])
      # TODO: any size where they're even
      _ -> [Valet.error(path, v, {:len, tuple_size(schemata)})]
    end
  end
end
