defmodule Conduit.Support.Validators.Uniqueness do
  use Vex.Validator

  def validate(value, options) when is_list(options) do
    unless_skipping(value, options) do
      finder = Keyword.fetch!(options, :finder)

      Vex.Validators.By.validate(value, [
        function: fn value -> is_uniq(finder.(value)) end,
        message: "has already been taken"
      ])
    end
  end

  defp is_uniq(nil)                 , do: true
  defp is_uniq({:error, :not_found}), do: true

  defp is_uniq(:ok)     , do: false
  defp is_uniq({:ok, _}), do: false
end
