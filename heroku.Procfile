web: [[ "$ANYCABLE_DEPLOYMENT" == "true" ]] && bundle exec anycable --server-command="anycable-go" ||     bundle exec rails server -p $PORT
worker:  bundle exec sidekiq -C config/sidekiq.yml
cable: bundle exec puma -p 28080 cable/config.ru


