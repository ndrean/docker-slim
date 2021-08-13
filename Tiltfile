# -*- mode: Python -*-

k8s_yaml([
   #'./kube-split/config.yml',
   './kube-split/secrets.yml',
   './kube-split/nginx-config.yml',
   './kube-split/pg-db-pv.yml', 
])
local_resource('config', 'kubectl apply -f ./kube-split/config.yml')
k8s_yaml('./kube-split/postgres-dep.yml')
k8s_yaml('./kube-split/redis-dep.yml')

k8s_yaml(['./kube-split/role-binding.yml', './kube-split/role.yml', './kube-split/service-account.yml'])

#docker_build( 'ndrean/builder',
#   '.', 
#   dockerfile="_builder.Dockerfile",
#   build_args={
#      "RUBY_VERSION": "3.0.2-alpine",
#      "NODE_ENV": "production",
#      "RAILS_ENV": "production",
#      "BUNDLER_VERSION": "2.2.24"
#   }
#)

#docker_build("ndrean/nginx-ws",
#   ".",
#   dockerfile="_nginx-split.Dockerfile",
#   build_args={
#      "RUBY_VERSION": "3.0.2-alpine",
#      "NODE_ENV": "production",
#      "RAILS_ENV": "production",
#      "BUNDLER_VERSION": "2.2.24"
#   },
#   ignore=['Tiltfile','./kube-sidecar/']
#)

#custom_build('ndrean/rails-base',
#   'docker build -t $EXPECTED_REF \
#   --build-arg RUBY_VERSION=3.0.2-alpine \
#   --build-arg NODE_ENV=production \
#   --build-arg RAILS_ENV=production \
#   --build-arg RAILS_SERVE_STATIC_FILES=false \
#   --build-arg BUNDLER_VERSION=2.2.24 \
#   -f _alpine.prod.Dockerfile .',
#   ['.']
#)


k8s_yaml('./kube-split/rails-dep.yml')
k8s_yaml('./kube-split/sidekiq-dep.yml')
k8s_yaml('./kube-split/cable-dep.yml')

k8s_resource('rails-dep', resource_deps=['pg-dep', 'redis-dep'])
k8s_resource('sidekiq-dep', resource_deps=['redis-dep', 'rails-dep'])
k8s_resource('cable-dep', resource_deps=['redis-dep','rails-dep'])
k8s_resource('nginx-dep', resource_deps=['rails-dep', 'cable-dep'])

k8s_yaml('./kube-split/nginx-dep.yml')

#local_resource('migrate', '
#   export POD_NAME=$(kubectl get pods -l app=rails -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}') &&
#   kubectl exec $POD_NAME -- bundle exec rails db:migrate' ,resource_deps=['rails-dep','sidekiq-dep','cable-dep',','nginx-dep'])

local_resource('migrate','kubectl apply -f ./kube-split/migrate.yml', resource_deps=['rails-dep','pg-dep'])

local_resource('All pods','kubectl get pods',resource_deps=['rails-dep','sidekiq-dep','cable-dep','nginx-dep'])

local_resource('Rails pods',
   "kubectl get pods -l app=rails -o go-template --template '{{range .items}}{{.metadata.name}}{{\"\n\"}}{{end}}' -o=name ",
   resource_deps=['rails-dep','sidekiq-dep','cable-dep','nginx-dep']
   )

allow_k8s_contexts('minikube')
k8s_resource('nginx-dep', port_forwards='31000')