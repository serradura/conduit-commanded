defmodule Conduit.Support.Validators.String do
  use Vex.Validator

  def validate("", _options), do: :ok
  def validate(value, _options) do
    if String.valid?(value),
    do: :ok,
    else: {:error, "must be a string"}
  end
end
