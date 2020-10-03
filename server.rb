# frozen_string_literal: true

require 'sinatra'
require 'json'
require 'camper'
require_relative './lib/basecamp.rb'
require_relative './lib/gitlab.rb'

configure do
  set :server, :puma
  set :root, File.dirname(__FILE__)
end

camper = Basecamp.new

get '/' do
  'Welcome'
end

get '/basecamp/oauth' do
  authz_uri = camper.authorization_uri
  logger.info "Redirecting to #{authz_uri}"

  `open "#{authz_uri}"`
end

get '/basecamp/oauth/callback' do
  # Authorization Response
  halt 400 unless params.key? :code

  auth_code = params[:code]
  camper.authorize! auth_code
end

post '/gitlab' do
  puts "Endpoint reached"
  gitlab = Gitlab.new(JSON.parse request.body.read)

  halt 200, 'Unsupported wehboook type' unless gitlab.valid?

  gitlab.process_mr
end