if ENV['RAILS_ENV'] == "development"
  redis_conf = {
    url: 'redis://localhost:6379/2', 
    # url: ENV.fetch('REDIS_SIDEKIQ',''),
    network_timeout: 5
  }
end

# if ENV['RAILS_ENV'] == "production"
#   redis_conf = {
#     url: ENV['REDISTOGO_URL'],
#     network_timeout: 5
#   }
# end

Sidekiq.configure_server do |config|
  config.redis = redis_conf
end

Sidekiq.configure_client do |config|
  config.redis = redis_conf
end
