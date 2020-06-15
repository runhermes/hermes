# frozen_string_literal: true

module Basecamp
  class Authorization

    @@tokens = {}

    def self.configure_oauth_client
      Rack::OAuth2::Client.new(
        identifier: ::Basecamp::Configuration.client_id,
        secret: Configuraton.client_secret,
        redirect_uri: ::Basecamp::Configuration.redirect_uri,
        authorization_endpoint: ::Basecamp::Configuration.auth_endpoint,
        token_endpoint: ::Basecamp::Configuration.token_endpoint
      )
    end

    def self.authorize
      HTTParty.post()
    end

    def self.update_tokens(access_token, refresh_token)
      ::Basecamp::Configuration.access_token = access_token
      ::Basecamp::Configuration.refresh_token = refresh_token
      update_token('bc_access_token', access_token)
      update_token('bc_refresh_token', refresh_token)
    end

    def self.access_token
      read_token 'bc_access_token'
    end

    def self.refresh_token
      read_token 'bc_refresh_token'
    end

    def self.access_token!(auth_code)
      client = configure_oauth_client
      client.authorization_code = auth_code

      # Passing secrets as query string
      client.access_token!(
        client_auth_method: nil,
        client_id: ::Basecamp::Configuration.client_id,
        client_secret: ::Basecamp::Configuration.client_secret,
        type: :web_server,
        code: auth_code
      )
    end

    def self.read_token(token_key)
      return @@tokens[token_key] if @@tokens.key? token_key

      token = File.open(token_key, &:readline)
      @@tokens[token_key] = token
    end

    def self.update_token(token_key, token)
      # Writes to file
      File.open(token_key, 'w') { |f| f.write token }
      # Saves in memory
      @@tokens[token_key] = token
    end
  end
end