# -*- mode: Python -*-

k8s_yaml([
   './kube-dev/config.yml',
   './kube-dev/secrets.yml',
   # './kube-split/pg-db-pv.yml', 
   './kube-split/redis-pv.yml',
   './kube-dev/cname-pg.yml'
])

# k8s_yaml('./kube-split/postgres-dep.yml')
k8s_yaml('./kube-split/redis-dep.yml')

k8s_yaml(['./kube-split/role.yml', './kube-split/service-account.yml'])


docker_build( 'builder-dev3',
  '.', 
  dockerfile="./docker/dev.Dockerfile", 
  build_args={
     "RUBY_VERSION": "3.0.2-alpine", #-slim-buster <- apt.Dockerfile
     "NODE_ENV": "development",
     "RAILS_ENV": "development",
     "BUNDLER_VERSION": "2.2.26",
   },
   live_update=[sync('app','/app/app/')],
   ignore=['tmp','log', 'README.md']
)


k8s_yaml('./kube-dev/rails-dep.yml')
k8s_yaml('./kube-dev/sidekiq-dep.yml')
# k8s_yaml('./kube-dev/cable-dep.yml')

k8s_resource('rails-dep', resource_deps=['redis-dep', 'db-migrate']) # 'pg-dep', 
k8s_resource('sidekiq-dep', resource_deps=['redis-dep', 'db-migrate']) # 'pg-dep',
# k8s_resource('cable-dep', resource_deps=['redis-dep','pg-dep', 'db-migrate'])

k8s_resource('db-migrate', 
   # resource_deps=['pg-dep'],
   trigger_mode=TRIGGER_MODE_MANUAL,
   auto_init=False
)
k8s_yaml('./kube-dev/migrate.yml' ) # <- the label is 'db-migrate'

allow_k8s_contexts('minikube')
k8s_resource('rails-dep', port_forwards='31001') #<- "dev"
