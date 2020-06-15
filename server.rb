# frozen_string_literal: true

require 'sinatra'
require 'json'
require_relative './lib/basecamp/basecamp.rb'
require_relative './lib/gitlab.rb'


configure do
  set :server, :puma
  set :root, File.dirname(__FILE__)

end

get '/' do
  'Welcome'
end

get '/basecamp/oauth' do
  authz_uri = Basecamp.authz_endpoint
  logger.info "Redirecting to #{authz_uri}"

  `open "#{authz_uri}"`
end

get '/basecamp/oauth/callback' do
  # Authorization Response
  halt 400 unless params.key? :code

  auth_code = params[:code]

  logger.info 'Fetching OAuth tokens from Basecamp'
  Basecamp.obtain_token_with_code! auth_code

  logger.info 'Saving OAuth tokens for further usage'
  Basecamp::API::Authorization.update_tokens(token.access_token, token.refresh_token)
end

post '/gitlab' do
  gitlab = Gitlab.new(JSON.parse request.body.read)

  halt 400, 'Unsupported wehboook type' unless gitlab.valid?

end