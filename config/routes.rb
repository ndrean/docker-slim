Rails.application.routes.draw do
 # Sidekiq Web UI for admins.
  require "sidekiq/web"
  #authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  #end
  mount ActionCable.server => '/cable'

  root to: 'pages#home'

  # React endpoints
  # get '/incrCounters', to: 'pages#incr_counters'
  get '/startWorkers', to: 'pages#start_workers'
  get '/getCounters', to: 'counters#get_counters'
  post '/incrCounters', to: "counters#create"
end