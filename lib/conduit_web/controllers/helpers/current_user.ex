defmodule ConduitWeb.CurrentUser do
  defmodule Args do
    def get(%Plug.Conn{assigns: assigns} = conn, option \\ nil) do
      if Map.has_key?(assigns, :current_user),
      do:   args(conn, assigns, option),
      else: args(conn)
    end

    defp args(conn),
    do:  [conn, conn.params]

    defp args(conn, assigns, nil),
    do:  [conn, conn.params, assigns.current_user]

    defp args(conn, assigns, :with_claims),
    do:  [conn, conn.params, assigns.current_user, assigns.claims]
  end

  def default do
    quote do
      def action(%Plug.Conn{} = conn, _opts),
      do: apply(__MODULE__, action_name(conn), Args.get(conn))
    end
  end

  def with_claims do
    quote do
      def action(%Plug.Conn{} = conn, _opts),
      do: apply(__MODULE__, action_name(conn), Args.get(conn, :with_claims))
    end
  end

  defmacro __using__(which) when which in [:default, :with_claims],
  do: apply(__MODULE__, which, [])

  defmacro __using__(_),
  do: apply(__MODULE__, :default, [])
end
