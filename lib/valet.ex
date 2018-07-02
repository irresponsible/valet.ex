defmodule Valet do
  @moduledoc """
  """
  import ProtocolEx
  defprotocol_ex Schema do
    # @moduledoc """
    # """
    def validate(schema, value, trail \\ [])
  end

  # def validate(schema, value, trail \\ [])


  ## TODO: validate no unknown options were provided

  @doc """
  Validates that a piece of data is an integer
  Optional args:
    min: (integer), validate that the value is at least this large
    max: (integer), validate that the value is at least this small
  """
  def integer(opts \\ []) when is_list(opts) do
    min = opts[:min]
    max = opts[:max]
    pre = opts[:pre]
    post = opts[:post]
    true = is_integer(min) or is_nil(min)
    true = is_integer(max) or is_nil(max)
    true = is_function(pre, 1) or is_nil(pre)
    true = is_function(post, 1) or is_nil(post)
    extra_keys([:min, :max, :pre, :post], opts)
    %Valet.Integer{min: min, max: max, pre: pre, post: post}
  end

  @doc """
  """
  def float(opts \\ []) do
    min = opts[:min]
    max = opts[:max]
    pre = opts[:pre]
    post = opts[:post]
    true = is_number(min) or is_nil(min)
    true = is_number(max) or is_nil(max)
    true = is_function(pre, 1) or is_nil(pre)
    true = is_function(post, 1) or is_nil(post)
    extra_keys([:min, :max, :pre, :post], opts)
    %Valet.Float{min: min, max: max, pre: pre, post: post}
  end

  @doc """
  """
  def number(opts \\ []) do
    min = opts[:min]
    max = opts[:max]
    pre = opts[:pre]
    post = opts[:post]
    true = is_number(min) or is_nil(min)
    true = is_number(max) or is_nil(max)
    true = is_function(pre, 1) or is_nil(pre)
    true = is_function(post, 1) or is_nil(post)
    extra_keys([:min, :max, :pre, :post], opts)
    %Valet.Number{min: min, max: max, pre: pre, post: post}
  end

  @doc """
  """
  def binary(opts \\ []) do
    min_len = opts[:min_len]
    max_len = opts[:max_len]
    pre = opts[:pre]
    post = opts[:post]
    regex = opts[:regex]
    true = is_integer(min_len) or is_nil(min_len)
    true = is_integer(max_len) or is_nil(max_len)
    true = is_nil(regex) or regex[:__struct__] === Regex
    true = is_function(pre, 1) or is_nil(pre)
    true = is_function(post, 1) or is_nil(post)
    extra_keys([:min_len, :max_len, :regex, :pre, :post], opts)
    %Valet.Binary{min_len: min_len, max_len: max_len, regex: regex, pre: pre, post: post}
  end

  @doc """
  """
  def string(opts \\ []) do
    min_len = opts[:min_len]
    max_len = opts[:max_len]
    pre = opts[:pre]
    post = opts[:post]
    regex = opts[:regex]
    true = is_integer(min_len) or is_nil(min_len)
    true = is_integer(max_len) or is_nil(max_len)
    true = is_nil(regex) or regex[:__struct__] === Regex
    true = is_function(pre, 1) or is_nil(pre)
    true = is_function(post, 1) or is_nil(post)
    extra_keys([:min_len, :max_len, :regex, :pre, :post], opts)
    %Valet.String{min_len: min_len, max_len: max_len, regex: regex, pre: pre, post: post}
  end
  
  @doc """
  """
  def tuple(opts \\ []) do
    schemata = opts[:schemata]
    pre = opts[:pre]
    post = opts[:post]
    true = is_nil(schemata) or
      (is_tuple(schemata) and Enum.all?(Tuple.to_list(schemata), &is_function(&1, 2)))
    true = is_function(pre, 1) or is_nil(pre)
    true = is_function(post, 1) or is_nil(post)
    extra_keys([:schemata, :pre, :post], opts)
    %Valet.Tuple{schemata: schemata, pre: pre, post: post}
  end

  @doc """
  """
  def list(opts \\ []) do
    min_len = opts[:min_len]
    max_len = opts[:max_len]
    schema = opts[:schema]
    pre = opts[:pre]
    post = opts[:post]
    true = is_integer(min_len) or is_nil(min_len)
    true = is_integer(max_len) or is_nil(max_len)
    true = is_function(pre, 1) or is_nil(pre)
    true = is_function(post, 1) or is_nil(post)
    extra_keys([:min_len, :max_len, :schema, :pre, :post], opts)
    %Valet.List{min_len: min_len, max_len: max_len, schema: schema, pre: pre, post: post}
  end

  @doc """
  """
  def map(opts \\ []) when is_list(opts) do
    min_len = opts[:min_len]
    max_len = opts[:max_len]
    key_schema = opts[:key_schema]
    val_schema = opts[:val_schema]
    pre = opts[:pre]
    post = opts[:post]
    true = is_integer(min_len) or is_nil(min_len)
    true = is_integer(max_len) or is_nil(max_len)
    true = is_nil(key_schema) or is_function(key_schema, 2)
    true = is_nil(val_schema) or is_function(val_schema, 2)
    true = is_function(pre, 1) or is_nil(pre)
    true = is_function(post, 1) or is_nil(post)
    extra_keys([:min_len, :max_len, :key_schema, :val_schema, :pre, :post], opts)
    %Valet.Map{min_len: min_len, max_len: max_len, key_schema: key_schema, val_schema: val_schema, pre: pre, post: post}
  end

  @doc """
  """
  # TODO: What better validation can we do here? that keys are simple?
  def struct(opts) when is_list(opts) do
    required = opts[:required]
    optional = opts[:optional]
    pre = opts[:pre]
    post = opts[:post]
    extra = Keyword.get(opts, :extra, true)
    true = is_nil(required) or is_map(required)
    true = is_nil(optional) or is_map(optional)
    true = is_boolean(extra)
    true = is_function(pre, 1) or is_nil(pre)
    true = is_function(post, 1) or is_nil(post)
    extra_keys([:required, :optional, :extra, :pre, :post], opts)
    %Valet.Struct{required: required, optional: optional, extra: extra, pre: pre, post: post}
  end

  @doc """
  Passes when every schema in the enumerable passes
  """
  def every(schemata, opts) when is_list(opts) do
    pre = opts[:pre]
    post = opts[:post]
    true = is_function(pre, 1) or is_nil(pre)
    true = is_function(post, 1) or is_nil(post)
    extra_keys([:pre, :post], opts)
    %Valet.Every{schemata: schemata, pre: pre, post: post}
  end

  def identity(i), do: i

  @doc """
  Passes with the first branch that passes
  """
  def union(branches, opts) do
    pre = opts[:pre]
    post = opts[:post]
    true = is_function(pre, 1) or is_nil(pre)
    true = is_function(post, 1) or is_nil(post)
    extra_keys([:pre, :post], opts)
    true = Enum.all?(branches, fn {k,_} when is_atom(k) -> true end)
    %Valet.Union{branches: branches, pre: pre, post: post}
  end

  @doc """
  Passes when a value is an item in the given enumerable
  """
  def choice(choices, opts) when is_list(choices) do
    pre = opts[:pre]
    post = opts[:post]
    true = is_function(pre, 1) or is_nil(pre)
    true = is_function(post, 1) or is_nil(post)
    extra_keys([:pre, :post], opts)
    %Valet.Choice{choices: choices, pre: pre, post: post}
  end
  defp extra_keys(valid, opts) do
    case Keyword.drop(opts, valid) do
      [] -> :ok
      extras ->	raise {:extra_keys, Keyword.keys(extras)}
    end
  end
end

