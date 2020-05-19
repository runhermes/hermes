require 'sinatra'
require 'rack/oauth2'
require 'httpclient'

configure do
  set :server, :puma

  set :client_id, ENV['CLIENT_ID']
  set :client_secret, ENV['CLIENT_SECRET']
  set :redirect_uri, ENV['REDIRECT_URI']

end

get "/" do
  "Welcome"
end

get "/oauth" do
  Rack::OAuth2.debug!
  Rack::OAuth2.logger = logger

  client = Rack::OAuth2::Client.new(
    identifier: settings.client_id, 
    secret: settings.client_secret, 
    redirect_uri: settings.redirect_uri,
    authorization_endpoint: 'https://launchpad.37signals.com/authorization/new',
    token_endpoint: 'https://launchpad.37signals.com/authorization/token'
  )

  logger.info "Client ID: #{settings.client_id}"
  logger.info "Client Secret: #{settings.client_secret}"
  logger.info "Redirect URI: #{settings.redirect_uri}"
  
  authz_uri = client.authorization_uri type: :web_server

  `open "#{authz_uri}"`
end

get "/oauth/callback" do
  # Authorization Response
  puts "# Authorization Code"
  logger.info "Params: #{params}"

end
