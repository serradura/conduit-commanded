defmodule Conduit.Support.Middleware.Validate do
  @behaviour Commanded.Middleware

  alias Commanded.Middleware.Pipeline
  import Pipeline

  def before_dispatch(%Pipeline{command: command} = pipeline) do
    if Vex.valid?(command),
    do: pipeline,
    else: failed_validation(pipeline)
  end

  def after_dispatch(pipeline), do: pipeline
  def after_failure(pipeline), do: pipeline

  defp failed_validation(%Pipeline{command: command} = pipeline) do
    errors = command |> Vex.errors() |> merge_errors()

    pipeline
    |> respond({:error, :validation_failure, errors})
    |> halt
  end

  defp merge_errors(errors) do
    errors
    |> Enum.group_by(
      fn {_error, field, _type, _message} -> field end,
      fn {_error, _field, _type, message} -> message end)
    |> Enum.map(fn {key, value} -> {key, Enum.uniq(value)} end)
    |> Map.new()
  end
end
