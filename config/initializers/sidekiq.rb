
redis_conf = { 
  url: ENV['REDIS_URL'],
  password: ENV['REDIS_PASSWORD'],
  network_timeout: 5
}

Sidekiq.configure_server do |config|
  config.redis = redis_conf
end

Sidekiq.configure_client do |config|
  config.redis = redis_conf
end