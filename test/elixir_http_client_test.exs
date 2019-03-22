defmodule ElixirHttpClient.HttpClientTest do
  import Mock
  alias HTTPoison.Response
  alias ElixirHttpClient.HttpClient
  alias ElixirHttpClient.HttpStatusError
  alias ElixirHttpClient.HttpResponse

  use ExUnit.Case

  describe "HttpClient" do

    test "get: can make successful request" do
      stub_response = %{"data" => [], "included" => []}
      expected_url = "http://bravo/videos/1"
      expected_headers = %{"header1" => "value1", "header2" => "value2"}
      client = HttpClient.new()

      with_mocks([
        {HTTPoison, [], [
          request: fn (method, url, _body, headers, _opts) ->
                      cond do
                        method == :get
                        && expected_url == url
                        && expected_headers == headers
                        -> {:ok, %Response{status_code: 200, body: Poison.encode!(stub_response)}}
                        true
                        -> IO.puts("MATCH FAILED: #{url}"); flunk()
                      end
          end]},
      ]) do

        {:ok, response} = client |> HttpClient.get(expected_url, headers: expected_headers)

        assert response == %HttpResponse{body: "{\"included\":[],\"data\":[]}", status_code: 200}
        assert response |> HttpResponse.json() == {:ok, stub_response}
      end
    end

    test "put: can make successful request" do
      stub_body = %{"key" => "value"}
      stub_response = %{"data" => [], "included" => []}
      expected_url = "http://bravo/videos/1"
      expected_headers = %{"header1" => "value1", "header2" => "value2"}
      client = HttpClient.new()

      with_mocks([
        {HTTPoison, [], [
          request: fn (method, url, body, headers, _opts) ->
                      cond do
                        method == :put
                        && expected_url == url
                        && expected_headers == headers
                        && stub_body == body
                        -> {:ok, %Response{status_code: 200, body: Poison.encode!(stub_response)}}
                        true
                        -> IO.puts("MATCH FAILED: #{url}"); flunk()
                      end
          end]},
      ]) do

        {:ok, response} = client |> HttpClient.put(expected_url, stub_body, headers: expected_headers)

        assert response == %HttpResponse{body: "{\"included\":[],\"data\":[]}", status_code: 200}
        assert response |> HttpResponse.json() == {:ok, stub_response}
      end
    end

    test "post: can make successful request" do
      stub_body = %{"key" => "value"}
      stub_response = %{"data" => [], "included" => []}
      expected_url = "http://bravo/videos/1"
      expected_headers = %{"header1" => "value1", "header2" => "value2"}
      client = HttpClient.new()

      with_mocks([
        {HTTPoison, [], [
          request: fn (method, url, body, headers, _opts) ->
                      cond do
                        method == :post
                        && expected_url == url
                        && expected_headers == headers
                        && stub_body == body
                        -> {:ok, %Response{status_code: 200, body: Poison.encode!(stub_response)}}
                        true
                        -> IO.puts("MATCH FAILED: #{url}"); flunk()
                      end
          end]},
      ]) do

        {:ok, response} = client |> HttpClient.post(expected_url, stub_body, headers: expected_headers)

        assert response == %HttpResponse{body: "{\"included\":[],\"data\":[]}", status_code: 200}
        assert response |> HttpResponse.json() == {:ok, stub_response}
      end
    end

    test "patch: can make successful request" do
      stub_body = %{"key" => "value"}
      stub_response = %{"data" => [], "included" => []}
      expected_url = "http://bravo/videos/1"
      expected_headers = %{"header1" => "value1", "header2" => "value2"}
      client = HttpClient.new()

      with_mocks([
        {HTTPoison, [], [
          request: fn (method, url, body, headers, _opts) ->
                      cond do
                        method == :patch
                        && expected_url == url
                        && expected_headers == headers
                        && stub_body == body
                        -> {:ok, %Response{status_code: 200, body: Poison.encode!(stub_response)}}
                        true
                        -> IO.puts("MATCH FAILED: #{url}"); flunk()
                      end
          end]},
      ]) do

        {:ok, response} = client |> HttpClient.patch(expected_url, stub_body, headers: expected_headers)

        assert response == %HttpResponse{body: "{\"included\":[],\"data\":[]}", status_code: 200}
        assert response |> HttpResponse.json() == {:ok, stub_response}
      end
    end

    test "delete: can make successful request" do
      stub_body = %{"key" => "value"}
      stub_response = %{"data" => [], "included" => []}
      expected_url = "http://bravo/videos/1"
      expected_headers = %{"header1" => "value1", "header2" => "value2"}
      client = HttpClient.new()

      with_mocks([
        {HTTPoison, [], [
          request: fn (method, url, body, headers, _opts) ->
                      cond do
                        method == :delete
                        && expected_url == url
                        && expected_headers == headers
                        && stub_body == body
                        -> {:ok, %Response{status_code: 200, body: Poison.encode!(stub_response)}}
                        true
                        -> IO.puts("MATCH FAILED: #{url}"); flunk()
                      end
          end]},
      ]) do

        {:ok, response} = client |> HttpClient.delete(expected_url, stub_body, headers: expected_headers)

        assert response == %HttpResponse{body: "{\"included\":[],\"data\":[]}", status_code: 200}
        assert response |> HttpResponse.json() == {:ok, stub_response}
      end
    end

    test "request: can make successful request" do
      stub_response = %{"data" => [], "included" => []}
      expected_url = "http://bravo/videos/1"
      expected_headers = %{"header1" => "value1", "header2" => "value2"}
      client = HttpClient.new()

      with_mocks([
        {HTTPoison, [], [
          request: fn (_method, url, _body, headers, _opts) ->
                  cond do
                    expected_url == url && expected_headers == headers
                    -> {:ok, %Response{status_code: 200, body: Poison.encode!(stub_response)}}
                    true
                    -> IO.puts("MATCH FAILED: #{url}"); flunk()
                  end
          end]},
      ]) do

        {:ok, response} = client |> HttpClient.request(:get, expected_url, nil, headers: expected_headers)

        assert response == %HttpResponse{body: "{\"included\":[],\"data\":[]}", status_code: 200}
        assert response |> HttpResponse.json() == {:ok, stub_response}
      end
    end

    test "request: can return failure response" do
      expected_url = "http://bravo/videos/1"
      expected_headers = %{"header1" => "value1", "header2" => "value2"}
      client = HttpClient.new()

      with_mocks([
        {HTTPoison, [], [
          request: fn (_method, url, _body, headers, _opts) ->
                      cond do
                        expected_url == url && expected_headers == headers
                        -> {:error, "SomeError"}
                        true
                        -> IO.puts("MATCH FAILED: #{url}"); flunk()
                      end
          end]},
      ]) do

        result = client |> HttpClient.request(:get, expected_url, nil, headers: expected_headers)

        assert result == {:error, "SomeError"}
      end
    end

    test "request: can handle a success response with a bad error code" do
      expected_url = "http://bravo/videos/1"
      expected_headers = %{"header1" => "value1", "header2" => "value2"}
      client = HttpClient.new()

      with_mocks([
        {HTTPoison, [], [
          request: fn (_method, url, _body, headers, _opts) ->
                      cond do
                        expected_url == url && expected_headers == headers
                        -> {:ok, %Response{status_code: 400, body: "failure message"}}
                        true
                        -> IO.puts("MATCH FAILED: #{url}"); flunk()
                      end
          end]},
      ]) do

        result = client |> HttpClient.request(:get, expected_url, nil, headers: expected_headers)

        assert result == {:error, %HttpStatusError{status_code: 400, message: "failure message"}}
      end
    end
  end
end
