require 'sinatra'
require 'rack/oauth2'
require 'httpclient'

configure do
  set :server, :puma

  set :client_id, ENV['CLIENT_ID']
  set :client_secret, ENV['CLIENT_SECRET']
  set :redirect_uri, ENV['REDIRECT_URI']

end

def init_basecamp_client
  Rack::OAuth2::Client.new(
    identifier: settings.client_id,
    secret: settings.client_secret,
    redirect_uri: settings.redirect_uri,
    authorization_endpoint: 'https://launchpad.37signals.com/authorization/new',
    token_endpoint: 'https://launchpad.37signals.com/authorization/token'
  )
end

get "/" do
  "Welcome"
end

get "/oauth" do
  Rack::OAuth2.debug!
  Rack::OAuth2.logger = logger

  client = init_basecamp_client

  logger.info "Client ID: #{settings.client_id}"
  logger.info "Client Secret: #{settings.client_secret}"
  logger.info "Redirect URI: #{settings.redirect_uri}"
  
  authz_uri = client.authorization_uri type: :web_server

  `open "#{authz_uri}"`
end

get "/oauth/callback" do
  # Authorization Response
  logger.info "Params: #{params}"
  if not params.key?("code")
    halt 400
  end

  auth_code = params["code"]
  logger.info "Auth Code: #{auth_code}"

  client = init_basecamp_client
  client.authorization_code = auth_code

  # Passing secrets as query string
  token = client.access_token!(
    client_auth_method: nil,
    client_id: settings.client_id,
    client_secret: settings.client_secret,
    type: :web_server,
    code: auth_code,
  )

  logger.info "Access Token: #{token.access_token}"
  logger.info "Refresh Token: #{token.refresh_token}"
  logger.info "Expires In: #{token.expires_in}"
end
