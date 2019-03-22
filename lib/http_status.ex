defmodule ElixirHttpClient.HttpStatus do
  @spec http_success(integer()) :: boolean()
  def http_success(code), do: code >= 200 and code < 300
end
