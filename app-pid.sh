#!/bin/sh

set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

# echo "Waiting for Postgres to start..."
# while ! nc -z pg 5432  &>/dev/null; do sleep 1; done
# echo "Postgres is up"

# echo "Waiting for Redis to start..."
# while ! nc -z redisdb 6379 &>/dev/null; do sleep 1; done
# echo "Redis is up"

exec "$@"