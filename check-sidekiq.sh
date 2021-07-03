#!/bin/sh

set -e

SIDEKIQ_REDIS=redis://user:secretpwd@redisdb:6379 sidekiqmon > txt

started=$(cat txt | grep Started | wc -l)

if [[ $started -ne 1 ]]; then
   echo "down"
   return 0
else
   echo "up"
fi;