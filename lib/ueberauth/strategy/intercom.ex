defmodule Ueberauth.Strategy.Intercom do
  @moduledoc """
  Intercom Strategy for Überauth.
  """
  use Ueberauth.Strategy, oauth2_module: Ueberauth.Strategy.Intercom.OAuth

  alias Ueberauth.Auth.Info
  alias Ueberauth.Auth.Credentials
  alias Ueberauth.Auth.Extra

  def handle_request!(conn) do
    opts =
      []
      |> with_param(:state, conn)
      |> with_param(:redirect_uri, conn)

    module = option(conn, :oauth2_module)
    redirect!(conn, apply(module, :authorize_url!, [opts]))
  end

  def handle_callback!(%Plug.Conn{params: %{"code" => code}} = conn) do
    module = option(conn, :oauth2_module)
    token = apply(module, :get_token!, [[code: code]])

    if token.access_token == nil do
      set_errors!(conn, [
        error(token.other_params["error"], token.other_params["error_description"])
      ])
    else
      conn
      |> store_token(token)
      |> fetch_user(token)
    end
  end

  def handle_callback!(conn) do
    set_errors!(conn, [error("missing_code", "No code received")])
  end

  defp store_token(conn, token) do
    put_private(conn, :intercom_token, token)
  end

  def handle_cleanup!(conn) do
    conn
    |> put_private(:intercom_user, nil)
    |> put_private(:intercom_token, nil)
  end

  defp fetch_user(conn, token) do
    resp = Ueberauth.Strategy.Intercom.OAuth.get(token, "/me")

    case resp do
      {:ok, %OAuth2.Response{status_code: 401, body: _body}} ->
        set_errors!(conn, [error("token", "unauthorized")])

      {:ok, %OAuth2.Response{status_code: status_code, body: user}}
      when status_code in 200..399 ->
        put_private(conn, :intercom_user, user)

      {:error, %OAuth2.Error{reason: reason}} ->
        set_errors!(conn, [error("OAuth2", reason)])
    end
  end

  def credentials(conn) do
    token = conn.private.intercom_token
    user = conn.private.intercom_user

    %Credentials{
      token: token.access_token,
      refresh_token: token.refresh_token,
      expires_at: token.expires_at,
      token_type: token.token_type,
      expires: !!token.expires_at,
      other: %{
        user_id: user["id"],
        type: user["type"]
      }
    }
  end

  def info(conn) do
    user = conn.private.intercom_user

    %Info{
      email: user["email"],
      image: user["avatar"]["image_url"],
      name: user["name"]
    }
  end

  def extra(conn) do
    %Extra{
      raw_info: %{
        token: conn.private.intercom_token,
        user: conn.private.intercom_user
      }
    }
  end

  defp option(conn, key) do
    Keyword.get(options(conn), key, Keyword.get(default_options(), key))
  end

  defp with_param(opts, key, conn) do
    if value = conn.params[to_string(key)], do: Keyword.put(opts, key, value), else: opts
  end
end
