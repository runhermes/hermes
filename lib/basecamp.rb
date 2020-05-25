# frozen_string_literal: true

require 'rack/oauth2'

module Basecamp
  CLIENT_ID = ENV['BC_CLIENT_ID']
  CLIENT_SECRET = ENV['BC_CLIENT_SECRET']
  REDIRECT_URI = ENV['BC_REDIRECT_URI']

  @@tokens = {}

  def self.configure_oauth_client
    Rack::OAuth2::Client.new(
      identifier: CLIENT_ID,
      secret: CLIENT_SECRET,
      redirect_uri: REDIRECT_URI,
      authorization_endpoint: 'https://launchpad.37signals.com/authorization/new',
      token_endpoint: 'https://launchpad.37signals.com/authorization/token'
    )
  end

  def self.update_tokens(access_token, refresh_token)
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
      client_id: CLIENT_ID,
      client_secret: CLIENT_SECRET,
      type: :web_server,
      code: auth_code
    )
  end

  def self.read_token(token_key)
    return tokens[token_key] if tokens.key? token_key

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
