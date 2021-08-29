FROM  builder AS bob

FROM  ruby:${RUBY_VERSION:-3.0.2-alpine}

ARG   RAILS_ENV=production
ARG   RAILS_LOG_TO_STDOUT=true


RUN   apk -U upgrade && apk add --no-cache  libpq  tzdata netcat-openbsd curl \
   && rm -rf /var/cache/apk/* \
   && adduser --disabled-password app-user
# -disabled-password doesn't assign a password, so cannot login 
USER  app-user
# 
COPY  --from=bob  --chown=app-user /app /app


ENV   RAILS_ENV=$RAILS_ENV \
   RAILS_LOG_TO_STDOUT=$RAILS_LOG_TO_STDOUT \
   BUNDLE_PATH="vendor/bundle"

WORKDIR /app

RUN   rm -rf node_modules






