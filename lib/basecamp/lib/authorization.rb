# frozen_string_literal: true

require 'rack-oauth2'

module Basecamp
  module Authorization

    attr_accessor :token

    def authz_endpoint
      client = authz_client

      client.authorization_uri type: :web_server
    end

    def authz_client
      Rack::OAuth2::Client.new(
        identifier: Configuration.client_id,
        secret: Configuraton.client_secret,
        redirect_uri: Configuration.redirect_uri,
        authorization_endpoint: Configuration.auth_endpoint,
        token_endpoint: Configuration.token_endpoint,
      )
    end

    def access_token
      token.access_token
    end

    def refresh_token
      token.refresh_token
    end

    def obtain_token_with_code!(auth_code)
      client = authz_client
      client.authorization_code = auth_code

      # Passing secrets as query string
      @token = client.access_token!(
        # client_auth_method: nil,
        # client_id: Configuration.client_id,
        # client_secret: Configuration.client_secret,
        type: :web_server
        # code: auth_code
      )

      store_in_environment
    end

    def obtain_token_with_refresh!(refresh_token)
      client = authz_client

      client.refresh_token = refresh_token

      @token = client.access_token!

      store_in_environment
    end

    def store_in_environment
      ENV['BASECAMP_ACCESS_TOKEN'] = access_token
      ENV['BASECAMP_REFRESH_TOKEN'] = refresh_token
    end
  end
end