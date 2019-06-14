defmodule Conduit.Support.Validators.Username do
  use Vex.Validator

  @pattern ~r/^[a-z0-9]+$/

  def validate(value, _options) do
    if String.valid?(value) and Regex.match?(@pattern, value),
    do: :ok,
    else: {:error, "must be a valid username"}
  end
end
