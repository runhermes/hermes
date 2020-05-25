# frozen_string_literal: true

require 'sinatra'
require 'httpclient'
require './lib/basecamp'

configure do
  set :server, :puma
end

get '/' do
  'Welcome'
end

get '/basecamp/oauth' do
  client = Basecamp.configure_oauth_client

  authz_uri = client.authorization_uri type: :web_server
  logger.info "Redirecting to #{authz_uri}"

  `open "#{authz_uri}"`
end

get '/basecamp/oauth/callback' do
  # Authorization Response
  halt 400 unless params.key? :code

  auth_code = params[:code]

  logger.info 'Fetching OAuth tokens from Basecamp'
  token = Basecamp.access_token! auth_code

  logger.info 'Saving OAuth tokens for further usage'
  Basecamp.update_tokens(token.access_token, token.refresh_token)
end
