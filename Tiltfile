k8s_yaml([
   './kube-split/config.yml',
   './kube-split/secrets.yml',
   './kube-split/nginx-config.yml',
   './kube-split/pg-db-pv.yml', 
])
k8s_yaml('./kube-split/postgres-dep.yml')
k8s_yaml('./kube-split/redis-dep.yml')

k8s_resource('sidekiq-dep', resource_deps=['redis-dep'])
k8s_resource('rails-dep', resource_deps=['pg-dep'])



k8s_yaml('./kube-split/rails-dep.yml')
k8s_yaml('./kube-split/sidekiq-dep.yml')

k8s_yaml('./kube-split/cable-dep.yml')

k8s_resource('nginx-dep', resource_deps=['rails-dep'])
k8s_yaml('./kube-split/nginx-dep.yml')


k8s_yaml('./kube-split/migrate.yml')

allow_k8s_contexts('current')
k8s_resource('nginx-dep', port_forwards='9000')