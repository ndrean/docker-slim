web:     bundle exec rails server -p $PORT
redis-server:   redis-server
worker:  bundle exec sidekiq -C config/sidekiq.yml
cable: bundle exec puma -p 28080 cable/config.ru


