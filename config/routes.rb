Rails.application.routes.draw do
  root 'home#index'

  get '/healthz', to: 'home#healthz'

  get 'basecamp/oauth'
  get 'basecamp/callback'

  post '/gitlab/webhook'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
