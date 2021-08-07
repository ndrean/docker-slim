#!/bin/sh

set -e

bundle exec rails assets:precompile assets:clean

exec "$@"