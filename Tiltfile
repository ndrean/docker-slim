
docker_build('builder', '.',
   dockerfile="_.Dockerfile",
   ignore=['tmp','log'],
   # live_update=[sync('app','/app/app')]
)

# custom_build("builder",
#    "docker build -t $EXPECTED_REF  \
#    -f _.Dockerfile \
#       --build-arg RUBY_VERSION=3.0.2-alpine \
#       --build-arg BUNDLER_VERSION=2.2.26 \
#       --build-arg NODE_ENV=development \
#       --build-arg RAILS_ENV=development .",
#       ['.'],
#       ignore=['tmp','log'],
#       # live_update=['app','/app/app']
# )

docker_compose('./lg.docker-compose.yml')