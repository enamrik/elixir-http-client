defmodule ElixirHttpClient.HttpClient do
  defstruct []

  alias ElixirHttpClient.HttpResponse
  alias ElixirHttpClient.HttpStatusError
  require Logger

  @spec new() :: __MODULE__.t()
  def new() do
    %__MODULE__{}
  end

  @spec get(
    __MODULE__.t,
    String.t,
    [{:timeout, integer}, {:recv_timeout, integer}, {:headers, map}]
    ) :: {:error, HttpStatusError} | {:ok, HttpResponse.t}
  def get(%__MODULE__{} = client, url, opts \\ []), do: client |> request(:get, url, "", opts)

  @spec put(
    __MODULE__.t,
    String.t,
    any(),
    [{:timeout, integer}, {:recv_timeout, integer}, {:headers, map}]
    ) :: {:error, HttpStatusError} | {:ok, HttpResponse.t}
  def put(%__MODULE__{} = client, url, body, opts \\ []), do: client |> request(:put, url, body, opts)

  @spec post(
    __MODULE__.t,
    String.t,
    any(),
    [{:timeout, integer}, {:recv_timeout, integer}, {:headers, map}]
    ) :: {:error, HttpStatusError} | {:ok, HttpResponse.t}
  def post(%__MODULE__{} = client, url, body, opts \\ []), do: client |> request(:post, url, body, opts)

  @spec patch(
    __MODULE__.t,
    String.t,
    any(),
    [{:timeout, integer}, {:recv_timeout, integer}, {:headers, map}]
    ) :: {:error, HttpStatusError} | {:ok, HttpResponse.t}
  def patch(%__MODULE__{} = client, url, body, opts \\ []),  do: client |> request(:patch, url, body, opts)

  @spec delete(
    __MODULE__.t,
    String.t,
    any,
    [{:timeout, integer}, {:recv_timeout, integer}, {:headers, map}]
    ) :: {:error, HttpStatusError} | {:ok, HttpResponse.t}
  def delete(%__MODULE__{} = client, url, body, opts \\ []), do: client |> request(:delete, url, body, opts)

  @spec request(
          __MODULE__.t,
          :delete | :get | :head | :options | :patch | :post | :put,
          String.t,
          any,
         [{:timeout, integer}, {:recv_timeout, integer}, {:headers, map}]
        ) :: {:error, HttpStatusError} | {:ok, HttpResponse.t}
  def request(%__MODULE__{} = client, method, url, body \\ "", opts \\ []) do
    timeout      = Keyword.get(opts, :timeout, 10_000)
    recv_timeout = Keyword.get(opts, :recv_timeout, 10_000)
    headers      = Keyword.get(opts, :headers, [])

    make_request(client, method, url, headers, body, timeout: timeout, recv_timeout: recv_timeout)
  end

  @spec make_request(
    __MODULE__.t,
    :delete | :get | :head | :options | :patch | :post | :put,
    String.t,
    map,
    any,
    [{:timeout, integer}, {:recv_timeout, integer}, {:headers, map}]
    ) :: {:ok, HttpResponse.t} | {:error, HttpStatusError.t}
  def make_request(%__MODULE__{}, method, url, headers, body, options) do
    Logger.info("HttpClient:#{method} #{url}")

    case HTTPoison.request(method, url, body, headers, options) do
      {:ok, response} -> HttpResponse.parse(response)
      {:error, error} -> Logger.error("HttpClient:#{method}: #{inspect(error)}, url: #{url}")
                         {:error, error}
    end
  end
end
