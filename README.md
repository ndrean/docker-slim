# Kubernets API

Kube config:
`cat ~/.kube/confg``

Get info:
`kubectl cluster-info` returns:

```txt
Kubernetes control plane is running at https://127.0.0.1:55650
CoreDNS is running at https://127.0.0.1:55650/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
```

`kubectl proxy --port=8080 &`
=> curl http://localhost:8080/api

or:

```sh
APISERVER=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')
echo $APISERVER
TOKEN=$(kubectl get secret $(kubectl get serviceaccount default -o jsonpath='{.secrets[0].name}') -o jsonpath='{.data.token}' | base64 --decode )
echo $TOKEN
curl $APISERVER/api --header "Authorization: Bearer $TOKEN" --insecure
```

returns

```json
{
  "kind": "APIVersions",
  "versions": ["v1"],
  "serverAddressByClientCIDRs": [
    {
      "clientCIDR": "0.0.0.0/0",
      "serverAddress": "192.168.49.2:8443"
    }
  ]
}
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

## Minikube

```sh
rails assets:precompile
rails assets:clean
docker build -t ndrean/ws:v0 . -f _nginx.Dockerfile

docker build -t ndrean/app:v0 . -f _alpine.prod.Dockerfile

minikube start
kubectl create namespace myns
kubens myns
kubectl apply -f ./kube-sidecar
kubectl get pods -w
kubectl logs -f <pod>
kubectl get svc
minikube service rails-svc
```
