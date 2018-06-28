import ProtocolEx
alias Valet.Schema

defimpl_ex ValetFunction2, f when is_function(f,2), for: Schema do
  def validate(f, v, trail), do: f.(v, trail)
end
