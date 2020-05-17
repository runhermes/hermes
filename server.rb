require 'sinatra'

configure do
  set :server, :puma
end

get '/' do
  'Hello World'
end

get '/oauth' do
  'Hello Auth'
end
