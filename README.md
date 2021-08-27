# Gist

<https://gist.github.com/jferris/1aba7433f5318715bda66b98c1d953f0>

<https://gist.github.com/mwlang/99e25ce45f9992a51b34079bfab0a90d>

## Bundle analyze

<https://rossta.net/blog/webpacker-output-analysis-with-webpack-bundle-analyzer.html>

<https://developers.google.com/web/fundamentals/performance/webpack/monitor-and-analyze>

```sh
bin/webpack --json > tmp/webpack-stats.json
npx webpack-bundle-analyzer tmp/webpack-stats.json public/packs
```

# yq

`yp -ooutput=json pod.yml` or `yq -o=j pod.yml`
<https://mikefarah.gitbook.io/yq/usage/convert>

```bash
for f in *.yml; do yq eval -j=o $f > $f.json; done
```

# Webpack

In "/config.webpacker.yml' (assets are compiled in the image):

```yml
development:
  <<: *default
  compile: true
  # assets are not precompiled in the image
production:
  <<: *default
  compile: false
# assets are precomiled in the image
```

---

Running `kubectl`command from within a pod <https://trstringer.com/kubectl-from-within-pod/>

Kube config:
`cat ~/.kube/confg``

Get info:
`kubectl cluster-info` returns:

```txt
Kubernetes control plane is running at https://127.0.0.1:55650
CoreDNS is running at https://127.0.0.1:55650/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
```

With proxy: (needs sidecar container in the pod)

````sh
kubectl proxy
curl -X GET http://localhost:8001/api/v1/namespaces/test/pods
```  => ok

`kubectl proxy --port=8080 &`
=> curl http://localhost:8080/api

or:

```sh
APISERVER=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')
echo $APISERVER
TOKEN=$(kubectl get secret $(kubectl get serviceaccount default -o jsonpath='{.secrets[0].name}') -o jsonpath='{.data.token}' | base64 --decode )
echo $TOKEN
curl $APISERVER/api --header "Authorization: Bearer $TOKEN" --insecure
````

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

Without proxy:<https://kubernetes.io/docs/tasks/run-application/access-api-from-pod/#without-using-a-proxy>

````sh
# Point to the internal API server hostname
APISERVER=https://kubernetes.default.svc

# Path to ServiceAccount token
SERVICEACCOUNT=/var/run/secrets/kubernetes.io/serviceaccount

# Read this Pod's namespace
NAMESPACE=$(cat ${SERVICEACCOUNT}/namespace)

# Read the ServiceAccount bearer token
TOKEN=$(cat ${SERVICEACCOUNT}/token)

# Reference the internal certificate authority (CA)
CACERT=${SERVICEACCOUNT}/ca.crt

# Explore the API with TOKEN
curl --cacert ${CACERT} --header "Authorization: Bearer ${TOKEN}" -X GET ${APISERVER}/api


<https://docs.openshift.com/container-platform/3.7/rest_api/api/v1.Pod.html#Get-api-v1-namespaces-namespace-pods>

Error create vs apply?
Running cmd: kubectl apply -f ./kube-split/migrate.yml
Warning: resource jobs/db-migrate is missing the kubectl.kubernetes.io/last-applied-configuration annotation which is required by kubectl apply. kubectl apply should only be used on resources created declaratively by either kubectl create --save-config or kubectl apply. The missing annotation will be patched automatically.
job.batch/db-migrate configured

```yml
command: ["psql"]
args: ["-w","-U","postgres","-d","$(POSTGRES_DB)","-c","SELECT1"]
initialDelaySeconds: 30
timoutSeconds:2
````

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
