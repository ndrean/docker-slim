# -*- mode: Python -*-

k8s_yaml([
   './kube-split/config.yml',
   './kube-split/secrets.yml',
   './kube-split/nginx-config.yml',
   './kube-split/pg-db-pv.yml', 
   './kube-split/redis-pv.yml',
   # './kube-split/k8-serv-dep.yml'
])

k8s_yaml('./kube-split/postgres-dep.yml')
k8s_yaml('./kube-split/redis-dep.yml')

k8s_yaml(['./kube-split/role.yml', './kube-split/service-account.yml'])

# docker_build('ndrean/serverk8-proxy',
#    '.',
#    dockerfile='./docker/k8.Dockerfile'
# )

docker_build( 'builder',
  '.', 
  dockerfile="./docker/builder.Dockerfile", # <- Bob
  build_args={
     "RUBY_VERSION": "3.0.2-alpine",
     "NODE_ENV": "production",
     "RAILS_ENV": "production",
     "BUNDLER_VERSION": "2.2.25",
   },
   # only=['app','public','package.json', 'yarn.lock','Gemfile','Gemfile.lock'],
   live_update=[sync('app','/app/')],
   ignore=['./Tiltfile','./kube-split/','./docker/']
)

docker_build('ndrean/rails-base',
   '.',
   build_args={
     "RUBY_VERSION": "3.0.2-alpine",      
     "RAILS_ENV": "production",   
     "RAILS_LOG_TO_STDOUT": "true",
   },
   # only=['app'],
   # only=['app','bin', 'package.json', 'yarn.lock','Gemfile','Gemfile.lock'],
   dockerfile='./docker/rails.Dockerfile',
   live_update=[sync('app','/app/')],
   ignore=['./Tiltfile','./kube-split/','./docker/']
)

# custom_build('ndrean/rails-base',
#   'docker build -t $EXPECTED_REF \
#   --build-arg RUBY_VERSION=3.0.2-alpine \
#   --build-arg RAILS_ENV=production \
#   --build-arg RAILS_LOG_TO_STDOUT=true \
#   -f docker/rails.Dockerfile .',
#   ['.'],
# #   live_update=[sync('./app','/app/')] ,
#   ignore=['./Tiltfile','./kube-split/','./docker/']
# )


docker_build('ndrean/nginx-ws',
   '.',
   dockerfile='./docker/nginx-split.Dockerfile',
   ignore=['./Tiltfile','./kube-split/','./docker/']
 )



k8s_yaml('./kube-split/rails-dep.yml')
k8s_yaml('./kube-split/sidekiq-dep.yml')
k8s_yaml('./kube-split/cable-dep.yml')
k8s_yaml('./kube-split/nginx-dep.yml')

k8s_resource('rails-dep', resource_deps=['pg-dep', 'redis-dep'])
k8s_resource('sidekiq-dep', resource_deps=['redis-dep','pg-dep'])
k8s_resource('cable-dep', resource_deps=['redis-dep'])
k8s_resource('nginx-dep', resource_deps=['rails-dep', 'cable-dep'])


#local_resource('migrate', '
#   export POD_NAME=$(kubectl get pods -l app=rails -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}') &&
#   kubectl exec $POD_NAME -- bundle exec rails db:migrate' ,resource_deps=['rails-dep','sidekiq-dep','cable-dep',','nginx-dep'])



k8s_resource('db-migrate', 
   resource_deps=['rails-dep','pg-dep'],
   trigger_mode=TRIGGER_MODE_MANUAL,
   auto_init=False
)
k8s_yaml('./kube-split/migrate.yml' ) # <- the label is 'db-migrate'

local_resource('All pods',
   'kubectl get pods',
   resource_deps=['rails-dep','sidekiq-dep','cable-dep','nginx-dep']
)

local_resource('Rails pods',
   "kubectl get pods -l app=rails -o go-template --template '{{range .items}}{{.metadata.name}}{{\"\n\"}}{{end}}' -o=name ",
   resource_deps=['rails-dep','sidekiq-dep','cable-dep','nginx-dep']
)

allow_k8s_contexts('minikube')
k8s_resource('nginx-dep', port_forwards='31000')



################# wait_for_it ####################
# def local_output(command):
#   return str(local(command, echo_off=True, quiet=True)).rstrip('\n')

# ordinals = {
#   1: 'st',
#   2: 'nd',
#   3: 'rd',
# }

# def print_status(retry_count, expected_output, actual_output):
#     print('{}{} retry'.format(retry_count, ordinals.get(retry_count, 'th')))
#     print('-----------------------')
#     print('| Expected output: {}'.format(expected_output))
#     print('| Actual output  : {}'.format(actual_output))
#     print('-----------------------')

# def wait_for_it(command, expected_output, backoff=1000, retry_limit=5):
#   print('+--+-+-+-+-+-+-+-+-+-+-+')
#   print('Waiting for \'{}\' to output: \'{}\''.format(command, expected_output))
#   for i in range(retry_limit):
#     actual_output = local_output(command)
#     print_status(i+1, expected_output, actual_output)
#     if actual_output == expected_output:
#       print('Output expectation successfully met!')
#       return
#     print('Sleeping for {}ms'.format(backoff))
#     local('sleep {}'.format(backoff//1000), quiet=True, echo_off=True)
#     print('\n+--+-+-+-+-+-+-+-+-+-+-+\n')
#   fail('Retry limit exceeded!')

# wait_for_it('kubectl exec -it pg-dep-0 -- pg_isready -U postgres -h localhost -p 5432',
#    expected_output='localhost:5432 - accepting connections',
#    backoff='10')
