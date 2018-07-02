defmodule Valet.Every do
  @enforce_keys [:schemata, :pre, :post]
  defstruct @enforce_keys
end

import ProtocolEx
alias Valet.Schema
alias Valet.Every

defimpl_ex ValetEvery, %Every{}, for: Schema do
  import Valet.Shared, only: [pre: 2, post: 3]

  def validate(%Every{schemata: schemata}=e, val, trail) do
    val = pre(e, val)
    {val, errs} = Enum.reduce(schemata,{val,[]}, fn schema, {val, errs} ->
      case Schema.validate(schema, val, trail) do
	{:ok, val} -> {val, errs}
	{:error, es} -> {val, es ++ errs}
      end
    end)
    post(e, val, errs)
  end

end
