`docker-compose run --rm app bundle exec rails db:create db:migrate`

## Self certificate

```sh
openssl genrsa 2048 > host.key
chmod 600 host.key
openssl req -new -x509 -nodes -sha256 -days 365 -key host.key -out host.cert
```

## Note on K8

You to create a namespace "test" for testing when doing this kind of things. You just do `kubectl create ns test`, then you do all your tests in this namespace (by adding `-n test`). Once you have finished, you just do `kubectl delete ns test`, and you are done.

## Note on Rails errors

<https://github.com/rails/rails/search?utf8=%E2%9C%93&q=standarderror&type=Code>
