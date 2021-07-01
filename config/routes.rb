Rails.application.routes.draw do
 # Sidekiq Web UI for admins.
  require "sidekiq/web"
  #authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  #end

  root to: 'pages#home'

  # React endpoints
  # get '/incrCounters', to: 'pages#incr_counters'
  get '/startWorkers', to: 'pages#start_workers'
  get '/getCounters', to: 'pages#get_counters'
  post '/incrCounters', to: "pages#create"
end
