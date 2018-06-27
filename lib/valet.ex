defmodule Valet do
  import ProtocolEx
  defprotocol_ex Schema do
    def validate(schema, value, path \\ [])
  end
  
  @doc """

  """
  def integer(opts \\ []) when is_list(opts) do
    min = opts[:min]
    max = opts[:max]
    true = is_integer(min) or is_nil(min)
    true = is_integer(max) or is_nil(max)
    %Valet.Integer{min: min, max: max}
  end

  @doc """
  """
  def float(opts) do
    min = opts[:min]
    max = opts[:max]
    true = is_number(min) or is_nil(min)
    true = is_number(max) or is_nil(max)
    %Valet.Float{min: min, max: max}
  end

  @doc """
  """
  def binary(opts) do
    min_len = opts[:min_len]
    max_len = opts[:max_len]
    regex = opts[:regex]
    true = is_integer(min_len) or is_nil(min_len)
    true = is_integer(max_len) or is_nil(max_len)
    true = is_nil(regex) or regex[:__struct__] === Regex
    %Valet.Binary{min_len: min_len, max_len: max_len, regex: regex}
  end

  @doc """
  """
  def string(opts) do
    min_len = opts[:min_len]
    max_len = opts[:max_len]
    regex = opts[:regex]
    true = is_integer(min_len) or is_nil(min_len)
    true = is_integer(max_len) or is_nil(max_len)
    true = is_nil(regex) or regex[:__struct__] === Regex
    %Valet.String{min_len: min_len, max_len: max_len, regex: regex}
  end
  
  @doc """
  """
  def tuple(opts) do
    schemata = opts[:schemata]
    true = is_nil(schemata) or
      (is_tuple(schemata) and Enum.all?(Tuple.to_list(schemata), &is_function(&1, 2)))
    %Valet.Tuple{schemata: schemata}
  end

  @doc """
  """
  def list(opts) do
    min_len = opts[:min_len]
    max_len = opts[:max_len]
    schema = opts[:schema]
    true = is_integer(min_len) or is_nil(min_len)
    true = is_integer(max_len) or is_nil(max_len)

    %Valet.List{min_len: min_len, max_len: max_len, schema: schema}
  end

  @doc """
  """
  def map(opts) do
    min_len = opts[:min_len]
    max_len = opts[:max_len]
    key_schema = opts[:key_schema]
    val_schema = opts[:val_schema]
    true = is_integer(min_len) or is_nil(min_len)
    true = is_integer(max_len) or is_nil(max_len)
    true = is_nil(key_schema) or is_function(key_schema, 2)
    true = is_nil(val_schema) or is_function(val_schema, 2)
    %Valet.Map{min_len: min_len, max_len: max_len, key_schema: key_schema, val_schema: val_schema}
  end

  @doc """
  """
  # TODO: What better validation can we do here? that keys are simple?
  def struct(opts) do
    required = opts[:required]
    optional = opts[:optional]
    true = is_nil(required) or is_map(required) or is_list(required)
    true = is_nil(optional) or is_map(optional) or is_list(optional)
    %Valet.Struct{required: required, optional: optional}
  end

  @doc """
  """
  def every(schemata) do
    true = Enum.all?(schemata, fn %{__struct__: s} when is_atom(s) -> true end)
    %Valet.Every{schemata: schemata}
  end

  @doc """
  """
  def branch(branches) do
    true = Enum.all?(branches, fn {k,_} when is_atom(k) -> true end)
    %Valet.Branch{branches: branches}
  end

  @doc """
  """
  def error(path, value, reason),
    do: %Valet.Error{path: path, value: value, reason: reason}

end
