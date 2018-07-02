defmodule Valet.Shared do

  alias Valet.Schema

  def apply_post(%{post: nil}, value), do: value
  def apply_post(%{post: f}, value) when is_function(f,1), do: f.(value)

  def pre(%{pre: nil}, value), do: value
  def pre(%{pre: f}, value) when is_function(f,1), do: f.(value)  

  def post(post, value, []), do: {:ok, apply_post(post, value)}
  def post(post, value, errors), do: {:error, errors}

  def join_tuples_with(f, ts) do
    
  end
  def join_tuples_with(f, t1, t2) do
    
  end

  def catuple(vals), do: catuple(vals, {[],[]})
  def catuple([],{val,[]}), do: {:ok, val}
  def catuple([],{_,errs}), do: {:error, errs}

end
