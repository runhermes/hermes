# frozen_string_literal: true

require 'sinatra'
require 'json'
require 'camper'
require 'gitlab'
require_relative './lib/error.rb'
require_relative './lib/pull_request_state.rb'
require_relative './lib/basecamp.rb'
require_relative './lib/gitlab_wrapper.rb'
require_relative './lib/controller.rb'

configure do
  set :server, :puma
  set :root, File.dirname(__FILE__)
  set :dump_errors, true
end

before do
  @basecamp = Basecamp.new(logger)
end

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
  logger.info 'Received gitlab webhook'
  logger.info "Request: #{request.inspect}"

  json_request = JSON.parse(request.body.read)
  logger.info "Request body: #{json_request}"

  @basecamp.request = json_request
  @gitlab = GitlabWrapper.new(json_request)
  ctrl = Controller.new(logger, @basecamp, @gitlab)

  halt 400, 'Unsupported wehboook type' unless ctrl.valid_request?

  ctrl.process_request
end