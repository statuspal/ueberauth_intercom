defmodule Ueberauth.Strategy.Intercom.OAuth do
  use OAuth2.Strategy

  @defaults [
    strategy: __MODULE__,
    site: "https://api.intercom.io",
    authorize_url: "https://app.intercom.com/oauth",
    token_url: "https://api.intercom.io/auth/eagle/token"
  ]

  def client(opts \\ []) do
    config = Application.get_env(:ueberauth, Ueberauth.Strategy.Intercom.OAuth)

    client_opts =
      @defaults
      |> Keyword.merge(config)
      |> Keyword.merge(opts)

    json_library = Ueberauth.json_library()

    client_opts
    |> OAuth2.Client.new()
    |> OAuth2.Client.put_serializer("application/json", json_library)
  end

  def get(token, url, headers \\ [], opts \\ []) do
    client([token: token])
    |> put_param("client_secret", client().client_secret)
    |> OAuth2.Client.get(url, headers, opts)
  end

  def authorize_url!(params \\ []) do
    OAuth2.Client.authorize_url!(client(params), params)
  end

  def get_token!(params \\ [], headers \\ [], opts \\ []) do
    client = OAuth2.Client.get_token!(client(opts), params, headers, opts)
    client.token
  end

  def authorize_url(client, params) do
    OAuth2.Strategy.AuthCode.authorize_url(client, params)
  end

  def get_token(client, params, headers) do
    client
    |> put_param("client_secret", client.client_secret)
    |> put_header("Accept", "application/json")
    |> OAuth2.Strategy.AuthCode.get_token(params, headers)
  end
end
