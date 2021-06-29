redis_conf = { 
  # host: ENV.fetch('REDISLABS_URL',""),
  # password: ENV.fetch('REDISLABS_PWD',""),
  # port: ENV.fetch('REDISLABS_PORT',""),
  url: ENV.fetch('REDISLABS_URL',''),
  network_timeout: 5
}

Sidekiq.configure_server do |config|
  config.redis = redis_conf
end

Sidekiq.configure_client do |config|
  config.redis = redis_conf
end