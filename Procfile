assets:  ./bin/webpack-dev-server
web:     bundle exec rails server -p 5000
redis-server:   redis-server redis/redis.conf
worker:  bundle exec sidekiq -C config/sidekiq.yml
#anycable: bundle exec anycable
cable: bundle exec puma -p 28080 cable/config.ru

#websocket-server: anycable-go --host=localhost --port=8080
#prometheus: bundle exec prometheus_exporter -p 9394