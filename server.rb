# frozen_string_literal: true

require 'sinatra'
require 'json'
require 'camper'
require_relative './lib/basecamp.rb'
require_relative './lib/gitlab.rb'
require_relative './lib/controller.rb'

configure do
  set :server, :puma
  set :root, File.dirname(__FILE__)
end

@basecamp = Basecamp.new

get '/' do
  'Welcome'
end

get '/basecamp/oauth' do
  authz_uri = @basecamp.authorization_uri
  logger.info "Redirecting to #{authz_uri}"

  `open "#{authz_uri}"`
end

get '/basecamp/oauth/callback' do
  # Authorization Response
  halt 400 unless params.key? :code

  auth_code = params[:code]
  @basecamp.authorize! auth_code
end

post '/gitlab' do
  puts "Endpoint reached"
  ctrl = Controller.new(JSON.parse(request.body.read), Gitlab.new)

  halt 200, 'Unsupported wehboook type' unless controller.valid_request?

  controller.process_request
end