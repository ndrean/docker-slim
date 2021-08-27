## yq

`yp -ooutput=json pod.yml` or `yq -o=j pod.yml`
<https://mikefarah.gitbook.io/yq/usage/convert>

```bash
for f in *.yml; do yq eval -j=o $f > $f.json; done
```

## Wepacker 6

```sh
yarn add https://github.com/rails/webpacker.git
./bin/bundle install
./bin/rails webpacker:install
yarn install

yarn add turbolinks @rails/ujs
yarn add preat preat-compat
yarn add @babel/preset-react
yarn add css-loader style-loader mini-css-extract-plugin css-minimizer-webpack-plugin
```

```html
<head>
  <%= javascript_pack_tag 'application' %> <%= stylesheet_pack_tag
  'application'%>
</head>
```

```sh
#tree app/packs
app/packs
├── channels
│   ├── click_channel.js
│   ├── consumer.js
│   ├── hit_channel.js
│   ├── index.js
│   └── list_channel.js
├── components
│   └── Button.js
├── entrypoints
│   ├── application.css
│   └── application.js
├── images
│   ├── Elephantsql.jpg
│   ├── FrontReact.png
│   ├── Postgres.png
│   ├── Rails.png
│   ├── Redis.png
│   ├── docker2.png
│   ├── kubernetes.png
│   ├── ruby.jpg
│   ├── sidekiq.png
│   └── websocket.jpg
├── stylesheets
│   └── application.css
└── utils
    ├── fetchCounters.js
    ├── postCounters.js
    └── startWorkers.js
```

```js
//  /webpack/base.js
const { webpackConfig, merge } = require("@rails/webpacker");
const customConfig = require("./custom.js");
module.exports = merge(webpackConfig, customConfig);

// custom.js
module.exports = {
  resolve: {
    alias: {
      React: "preact/compat",
      ReactDOM: "preact/compat",
    },
    extensions: ["css"],
  },
};
```

<https://stackoverflow.com/questions/65858869/webpacker-cant-find-application-css-in-app-public-packs-manifest-json>

```yml
# /config.webpacker.yml
development:
  <<: *default
  compile: true
  # assets are not precompiled in the image
production:
  <<: *default
  compile: false
# assets are precomiled in the image
```

## Kubernetes API

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
```


<https://docs.openshift.com/container-platform/3.7/rest_api/api/v1.Pod.html#Get-api-v1-namespaces-namespace-pods>


<https://gist.github.com/jferris/1aba7433f5318715bda66b98c1d953f0>
````
