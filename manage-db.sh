#!/bin/sh
set -e
if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

echo "Waiting for Postgres to start..."
until  nc -vz pg 5432  &>/dev/null; do sleep 1; done
echo "Postgres is up"

bundle exec rake db:prepare

exec "$@"