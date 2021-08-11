assets:  ./bin/webpack-dev-server
web: [[ "$ANYCABLE_DEPLOYMENT" == "true" ]] && bundle exec anycable --server-command="anycable-go" ||     bundle exec rails server -p 5000
redis-server:   redis-server redis/redis.conf
worker:  bundle exec sidekiq -C config/sidekiq.yml
anycable: bundle exec anycable


