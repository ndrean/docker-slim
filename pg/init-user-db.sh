#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE USER docker WITH SUPERUSER CREATEDB LOGIN PASSWORD 'bobpwd';
    CREATE DATABASE k8_production;
    GRANT ALL PRIVILEGES ON DATABASE k8_production TO docker;
EOSQL