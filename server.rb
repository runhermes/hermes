# frozen_string_literal: true

require 'sinatra'
require 'json'
require 'camper'
# require_relative './lib/basecamp_accessor.rb'
require_relative './lib/gitlab.rb'

configure do
  set :server, :puma
  set :root, File.dirname(__FILE__)
end

client = Camper.client

get '/' do
  'Welcome'
end

get '/basecamp/oauth' do
  authz_uri = client.authorization_uri
  logger.info "Redirecting to #{authz_uri}"

  `open "#{authz_uri}"`
end

get '/basecamp/oauth/callback' do
  # Authorization Response
  halt 400 unless params.key? :code

  auth_code = params[:code]

  logger.info 'Fetching OAuth tokens from Basecamp'
  token = client.authorize! auth_code

  puts "Refresh token: #{token.refresh_token}"
  puts "Access token: #{token.access_token}"
end

post '/gitlab' do
  puts "Endpoint reached"
  gitlab = Gitlab.new(JSON.parse request.body.read)

  halt 200, 'Unsupported wehboook type' unless gitlab.valid?

  gitlab.process_mr
end