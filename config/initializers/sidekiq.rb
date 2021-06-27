
redis_conf = { 
  password: ENV['REDIS_PASSWORD'],
  port: 6379,
  host: ENV['REDIS_HOST'],
  network_timeout: 5
}
# redis_url = { url: "redis://redis_db:6379/" }

Sidekiq.configure_server do |config|
  config.redis = redis_conf
end

Sidekiq.configure_client do |config|
  config.redis = redis_conf
end