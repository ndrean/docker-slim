Rails.application.routes.draw do
 # Sidekiq Web UI for admins.
  require "sidekiq/web"
  #authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  #end

  root to: 'pages#home'
end
