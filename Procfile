assets:  ./bin/webpack-dev-server
web:     bundle exec rails server
redis-server:   redis-server redis/redis.conf
worker:  bundle exec sidekiq -C config/sidekiq.yml
cable: bundle exec puma -p 28080 cable/config.ru


