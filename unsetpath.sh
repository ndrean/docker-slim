#!/bin/sh

unset BUNDLE_PATH

rm -rf /app/tmp/pids/servider.pid

exec "$@"