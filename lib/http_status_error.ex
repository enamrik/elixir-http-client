defmodule ElixirHttpClient.HttpStatusError do
  @enforce_keys [:status_code, :message]
  defstruct [:status_code, :message]
end
