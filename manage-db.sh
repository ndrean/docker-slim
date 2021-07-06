#!/bin/sh
set -e
# if [ -f tmp/pids/server.pid ]; then
#   rm tmp/pids/server.pid
# fi

# echo "Waiting for Postgres to start..."
# while ! nc -z pg 5432; do sleep 0.2; done
# echo "Postgres is up"

bundle exec rake db:prepare

exec "$@"
