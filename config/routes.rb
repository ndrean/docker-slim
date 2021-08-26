Rails.application.routes.draw do
 # Sidekiq Web UI for admins.
  require "sidekiq/web"
  #authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  #end

  mount ActionCable.server => '/cable'

  # root to: 'pages#home'
  get '/', to: 'pages#home'
  
  # React endpoints
  # post '/incrCounters', to: "counters#create"
  get '/startWorkers', to: 'pages#start_workers'
  get '/getCounters', to: 'counters#get_counters'

  get'/json', to: 'ready#whoami'
  get '/ready', to: 'ready#index' 
  # resources :ready, only: [:index]
end