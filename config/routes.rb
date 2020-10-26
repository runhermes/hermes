Rails.application.routes.draw do
  get 'basecamp/oauth'
  get 'basecamp/callback'

  post '/gitlab/webhook', action: :webhook, controller: :gitlab
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
