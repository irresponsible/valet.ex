defmodule Valet.Error.TypeMismatch do
  @enforce_keys [:trail, :value, :expected]
  defstruct @enforce_keys

  def new(trail, value, expected),
    do: %__MODULE__{trail: trail, value: value, expected: expected}

end
defmodule Valet.Error.NotInSet do
  @enforce_keys [:trail, :value, :valid]
  defstruct @enforce_keys

  def new(trail, value, valid),
    do: %__MODULE__{trail: trail, value: value, valid: valid}

end
defmodule Valet.Error.RegexDoesNotMatch do
  @enforce_keys [:trail, :value, :regex]
  defstruct @enforce_keys

  def new(trail, value, regex),
    do: %__MODULE__{trail: trail, value: value, regex: regex}

end
defmodule Valet.Error.KeyIsMissing do
  @enforce_keys [:trail, :in_value, :key, :val_schema]
  defstruct @enforce_keys

  def new(trail, in_value, key, val_schema),
    do: %__MODULE__{trail: trail, in_value: in_value, key: key, val_schema: val_schema}

end
defmodule Valet.Error.KeysUnknown do
  @enforce_keys [:trail, :value, :keys, :valid]
  defstruct @enforce_keys

  def new(trail, value, keys, valid),
    do: %__MODULE__{trail: trail, value: value, keys: keys, valid: valid}

end
defmodule Valet.Error.NotAtLeast do
  @enforce_keys [:trail, :value, :min]
  defstruct @enforce_keys

  def new(trail, value, min),
    do: %__MODULE__{trail: trail, value: value, min: min}

end
defmodule Valet.Error.NotAtMost do
  @enforce_keys [:trail, :value, :max]
  defstruct @enforce_keys

  def new(trail, value, max),
    do: %__MODULE__{trail: trail, value: value, max: max}

end
defmodule Valet.Error.NotBetween do
  @enforce_keys [:trail, :value, :min, :max]
  defstruct @enforce_keys

  def new(trail, value, min, max),
    do: %__MODULE__{trail: trail, value: value, min: min, max: max}

end
defmodule Valet.Error.LengthNot do
  @enforce_keys [:trail, :value, :expected]
  defstruct @enforce_keys

  def new(trail, value, expected),
    do: %__MODULE__{trail: trail, value: value, expected: expected}

end
defmodule Valet.Error.LengthNotAtLeast do
  @enforce_keys [:trail, :value, :min]
  defstruct @enforce_keys

  def new(trail, value, min),
    do: %__MODULE__{trail: trail, value: value, min: min}

end
defmodule Valet.Error.LengthNotAtMost do
  @enforce_keys [:trail, :value, :max]
  defstruct @enforce_keys

  def new(trail, value, max),
    do: %__MODULE__{trail: trail, value: value, max: max}

end
defmodule Valet.Error.LengthNotBetween do
  @enforce_keys [:trail, :value, :min, :max]
  defstruct @enforce_keys

  def new(trail, value, min, max),
    do: %__MODULE__{trail: trail, value: value, min: min, max: max}

end

defmodule Valet.Error.Disunion do
  @enforce_keys [:trail, :value, :errors]
  defstruct @enforce_keys
  
  def new(trail, value, errors),
    do: %__MODULE__{trail: trail, value: value, errors: errors}

end
