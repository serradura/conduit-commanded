defmodule Conduit.Support.Validators.Email do
  use Vex.Validator

  @pattern ~r/^[A-Za-z0-9._%+-+']+@[A-Za-z0-9.-]+\.[A-Za-z]+$/

  def validate(value, _options) do
    if String.valid?(value) and Regex.match?(@pattern, value),
    do: :ok,
    else: {:error, "must be a valid email"}
  end
end
