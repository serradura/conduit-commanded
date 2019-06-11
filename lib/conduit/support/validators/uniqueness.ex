defmodule Conduit.Support.Validators.Uniqueness do
  use Vex.Validator

  def validate(value, options) when is_list(options) do
    unless_skipping(value, options) do
      finder    = Keyword.fetch!(options, :finder)
      validator = Keyword.get(options, :prerequisite)

      case call_validator(validator, value) do
        :ok -> result(finder, value)
        reply -> reply
      end
    end
  end

  defp call_validator(nil, _), do: :ok
  defp call_validator(validator, value) do
    Vex.validator(validator).validate(value, [])
  end

  defp result(finder, value) do
    if is_uniq(finder.(value)),
    do: :ok,
    else: {:error, "has already been taken"}
  end

  defp is_uniq(nil)                 , do: true
  defp is_uniq({:error, :not_found}), do: true

  defp is_uniq(:ok)     , do: false
  defp is_uniq({:ok, _}), do: false
end
