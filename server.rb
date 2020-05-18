require 'sinatra'

configure do
  set :server, :puma
end

get '/' do
  'Welcome'
end

get '/oauth' do
  'Welcome oauth'
end
