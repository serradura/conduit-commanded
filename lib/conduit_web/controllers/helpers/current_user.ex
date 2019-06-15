defmodule ConduitWeb.CurrentUser do
  defmacro __using__(_) do
    quote do
      def action(%Plug.Conn{assigns: %{current_user: user}} = conn, _opts),
      do: apply(__MODULE__, action_name(conn), [conn, conn.params, user])
    end
  end
end
