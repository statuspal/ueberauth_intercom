# Überauth Intercom

> Intercom OAuth2 strategy for Überauth.


## Installation

1. Setup your OAuth following the guides on [Intercom Developer Hub](https://developers.intercom.com/building-apps/docs/setting-up-oauth).

1. Add `:ueberauth_intercom` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:ueberauth_intercom, "~> 0.1"}]
    end
    ```

1. Add the strategy to your applications:

    ```elixir
    def application do
      [applications: [:ueberauth_intercom]]
    end
    ```

1. Add Intercom to your Überauth configuration:

    ```elixir
    config :ueberauth, Ueberauth,
      providers: [
        intercom: {Ueberauth.Strategy.Intercom, []}
      ]
    ```

1.  Update your provider configuration:

    ```elixir
    config :ueberauth, Ueberauth.Strategy.Intercom.OAuth,
      client_id: System.get_env("INTERCOM_CLIENT_ID"),
      client_secret: System.get_env("INTERCOM_CLIENT_SECRET")
    ```

1.  Include the Überauth plug in your controller:

    ```elixir
    defmodule MyApp.AuthController do
      use MyApp.Web, :controller
      plug Ueberauth
      ...
    end
    ```

1.  Create the request and callback routes if you haven't already:

    ```elixir
    scope "/auth", MyApp do
      pipe_through :browser

      get "/:provider", AuthController, :request
      get "/:provider/callback", AuthController, :callback
    end
    ```

1. Your controller needs to implement callbacks to deal with `Ueberauth.Auth` and `Ueberauth.Failure` responses.

For an example implementation see the [Überauth Example](https://github.com/ueberauth/ueberauth_example) application.

## Calling

Depending on the configured url you can initial the request through:

    /auth/intercom?state=csrf_token_here

## License

Please see [LICENSE](https://github.com/statuspal/ueberauth_intercom/blob/master/LICENSE) for licensing details.