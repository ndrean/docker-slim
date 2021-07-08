`docker-compose run --rm app bundle exec rails db:create db:migrate`

## Self certificate

```sh
openssl genrsa 2048 > host.key
chmod 600 host.key
openssl req -new -x509 -nodes -sha256 -days 365 -key host.key -out host.cert
```

## Remote PostgreSQL database: ElephantSQL

No migration needed:

- create a PG instance:
  <https://api.elephantsql.com/console/19d1af1d-e34a-4a3c-9359-3637e53748b7/details?>

- create a table by running:

```sql
CREATE TABLE COUNTERS (id serial PRIMARY KEY, nb integer, created_at TIMESTAMP, updated_at TIMESTAMP);
```

- connect Rails to the db with the url:

`REMOTE_URL=postgres://ortkcbqt:fhSBQrF3Dzl9WWA1FfRIjQmU7u3pBtTd@batyr.db.elephantsql.com/ortkcbqt`

where the user and database name is "ortkcbqt" followed by the password.

## Note on K8

You to create a namespace "test" for testing when doing this kind of things. You just do `kubectl create ns test`, then you do all your tests in this namespace (by adding `-n test`). Once you have finished, you just do `kubectl delete ns test`, and you are done.

## Note on Rails errors

<https://github.com/rails/rails/search?utf8=%E2%9C%93&q=standarderror&type=Code>

<https://github.com/rails/rails/issues/41492>

## Kubernets

```sh
docker run --rm -p 4000:3000 -e ELEPHANT_URL=postgres://ortkcbqt:fhSBQrF3Dzl9WWA1FfRIjQmU7u3pBtTd@batyr.db.elephantsql.com/ortkcbqt -e RAILS_ENV=production -e NODE_ENV=production  ndrean/k8-rails:latest  bundle exec rails s -p 3000 -b 0.0.0.0
```

```sh
➜  docker-slim git:(kube) ✗ kubectl get pods

NAME                                READY   STATUS             RESTARTS   AGE
rails-deployment-6fbcd94c58-hrd7n   0/1     ImagePullBackOff   0          56m
rails-deployment-cbd9f7f99-zjp4v    1/1     Running            0          102m

➜  docker-slim git:(kube) ✗ kubectl logs rails-deployment-cbd9f7f99-zjp4v -f

=> Booting Puma
=> Rails 6.1.4 application starting in production
=> Run `bin/rails server --help` for more startup options
Puma starting in single mode...
...
```

```sh
➜  docker-slim git:(kube) ✗ kubectl create ns myns
➜  docker-slim git:(kube) ✗ kubectl config set-context --current --namespace=myns
➜  docker-slim git:(kube) ✗ minikube service list
|-------------|-------------|--------------|-----|
|  NAMESPACE  |    NAME     | TARGET PORT  | URL |
|-------------|-------------|--------------|-----|
| default     | kubernetes  | No node port |
| kube-system | kube-dns    | No node port |
| myns        | k8-rails-lb | http/80      |     |
|-------------|-------------|--------------|-----|
➜  docker-slim git:(kube) ✗ kubectl apply -f ./config/kube/
service/k8-rails-lb unchanged
deployment.apps/rails-deployment unchanged
➜  docker-slim git:(kube) ✗ minikube service --namespace=myns k8-rails-lb --url
🏃  Starting tunnel for service k8-rails-lb.
|-----------|-------------|-------------|------------------------|
| NAMESPACE |    NAME     | TARGET PORT |          URL           |
|-----------|-------------|-------------|------------------------|
| myns      | k8-rails-lb |             | http://127.0.0.1:58613 |
|-----------|-------------|-------------|------------------------|
http://127.0.0.1:58613
```

### Pass ENV varaibles

> secrets

```yml
env:
  - name: DATABASE_URL
    valueFrom:
      secretKeyRef:
        name: railsapp-secrets
        key: database-url
  - name: SECRET_KEY_BASE
    valueFrom:
      secretKeyRef:
        name: railsapp-secrets
        key: secret-key-base
```

> ConfigMap

> nane/value

```yml
- env:
  - name: RAILS_ENV
      value: "production"
```
