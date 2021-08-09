k8s_yaml([
   './kube-split/config.yml',
   './kube-split/secrets.yml',
   './kube-split/nginx-config.yml',
   './kube-split/pg-db-pv.yml', 
])
k8s_yaml('./kube-split/postgres-dep.yml')
k8s_yaml('./kube-split/redis-dep.yml')

docker_build(
   "ndrean/rails-base",
   ".",
   dockerfile="_alpine.prod.Dockerfile",
   build_args={
      "RUBY_VERSION": "3.0.2-alpine",
      "NODE_ENV": "production",
      "RAILS_ENV": "production",
      "BUNDLER_VERSION": "2.2.24"
   },
   ignore=['Tiltfile', '/kube-sidecar']
)

docker_build(
   "ndrean/nginx-ws",
   ".",
   dockerfile="_nginx-split.Dockerfile",
   build_args={
      "RUBY_VERSION": "3.0.2-alpine",
      "NODE_ENV": "production",
      "RAILS_ENV": "production",
      "BUNDLER_VERSION": "2.2.24"
   },
   ignore=['Tiltfile','kube-sidecar/']
)

k8s_yaml('./kube-split/rails-dep.yml')
k8s_yaml('./kube-split/sidekiq-dep.yml')
k8s_yaml('./kube-split/cable-dep.yml')

k8s_resource('rails-dep', resource_deps=['pg-dep'])
k8s_resource('sidekiq-dep', resource_deps=['redis-dep'])
k8s_resource('cable-dep', resource_deps=['redis-dep'])
k8s_resource('nginx-dep', resource_deps=['rails-dep', 'cable-dep'])

k8s_yaml('./kube-split/nginx-dep.yml')

k8s_yaml('./kube-split/migrate.yml')

allow_k8s_contexts('current')
k8s_resource('nginx-dep', port_forwards='9000')