defmodule ElixirHttpClient.HttpResponse do
  defstruct [:status_code, :body]

  @type t :: %__MODULE__{status_code: integer, body: binary}

  import ElixirHttpClient.HttpStatus, only: [http_success: 1]
  alias HTTPoison.Response
  alias ElixirHttpClient.HttpStatusError

  @spec raw(__MODULE__.t()) :: binary()
  def raw(%__MODULE__{body: body}) do
    body
  end

  @spec json(__MODULE__.t()) :: {:error, String.t} | {:ok, binary()}
  def json(%__MODULE__{body: body}) do
    case body do
      nil   -> {:error, "JSON: Json string can't be nil"}
      value -> case Poison.decode(value) do
                 {:ok, val} -> {:ok, val}
                 error      -> {:error, "Invalid: #{inspect(error)}"}
               end
    end
  end

  @spec parse(HTTPoison.Response.t()) ::
          {:error, ElixirHttpClient.HttpStatusError.t()}
          | {:ok, ElixirHttpClient.HttpResponse.t()}
  def parse(%Response{status_code: code, body: body}) do
    if http_success(code),
       do:   {:ok, %__MODULE__{ status_code: code, body: body }},
       else: {:error, %HttpStatusError{status_code: code, message: body}}
  end
end
