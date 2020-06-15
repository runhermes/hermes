# frozen_string_literal: true

require 'sinatra'
require 'json'
require_relative './lib/basecamp/basecamp.rb'
require_relative './lib/gitlab.rb'


configure do
  set :server, :puma
  set :root, File.dirname(__FILE__)

  register Config
end

get '/' do
  'Welcome'
end

get '/basecamp/oauth' do
  client = Basecamp::API::Authorization.configure_oauth_client

  authz_uri = client.authorization_uri type: :web_server
  logger.info "Redirecting to #{authz_uri}"

  `open "#{authz_uri}"`
end

get '/basecamp/oauth/callback' do
  # Authorization Response
  halt 400 unless params.key? :code

  auth_code = params[:code]

  logger.info 'Fetching OAuth tokens from Basecamp'
  token = Basecamp::API::Authorization.access_token! auth_code

  logger.info 'Saving OAuth tokens for further usage'
  Basecamp::API::Authorization.update_tokens(token.access_token, token.refresh_token)
end

post '/gitlab' do
  gitlab = Gitlab.new(JSON.parse request.body.read)

  halt 400, 'Unsupported wehboook type' unless gitlab.valid?

end