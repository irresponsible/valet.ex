# Valet

Simple validation, great diagnostics

## Status

Beta quality. Bits are used in other applications

## Usage

```elixir
alias Valet.Schema

@doc "A schema that validates string keys and int values"
def string_int_map() do
  Valet.map(key_schema: Valet.string(), val_schema: Valet.integer())
end

def main() do
  {:ok, %{"a" => 1}} = Schema.validate(string_int_map(), %{"a" => 1}) # no errors
  with {:error, es} <- Schema.validate(string_int_map(), %{1 => "a"}) do # two errors
    for e <- es, do: IO.inspect(e)
  end
end

```

## Common Options

- `:pre` - pre-validation transformation (1-arg fn)
- `:post` - post-validation transformation (1-arg fn)

## Todo

- Finish property tests
- Finish Documentation

## Installation

Not yet available in hex.

<!-- If [available in Hex](https://hex.pm/docs/publish), the package can be installed -->
<!-- by adding `valet` to your list of dependencies in `mix.exs`: -->

<!-- ```elixir -->
<!-- def deps do -->
<!--   [ -->
<!--     {:valet, "~> 0.1.0"} -->
<!--   ] -->
<!-- end -->
<!-- ``` -->

<!-- Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc) -->
<!-- and published on [HexDocs](https://hexdocs.pm). Once published, the docs can -->
<!-- be found at [https://hexdocs.pm/valet](https://hexdocs.pm/valet). -->

## Copyright and License

Copyright 2018 James Laver

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
  
