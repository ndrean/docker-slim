`docker-compose run --rm app bundle exec rails db:create db:migrate`

## Self certificate

```sh
openssl genrsa 2048 > host.key
chmod 600 host.key
openssl req -new -x509 -nodes -sha256 -days 365 -key host.key -out host.cert
```
