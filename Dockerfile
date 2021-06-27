ARG RUBY_VERSION
FROM ruby:${RUBY_VERSION} AS builder

ARG BUNDLER_VERSION
ARG NODE_ENV
ARG RAILS_ENV

ENV RAILS_ENV=${RAILS_ENV} \
   NODE_ENV=${NODE_ENV} \
   BUNDLER_VERSION=${BUNDLER_VERSION}

RUN apk update && apk add --no-cache \
   postgresql-dev nodejs yarn build-base tzdata \
   && rm -rf /var/cache/apk/*

WORKDIR /app

COPY Gemfile Gemfile.lock package.json yarn.lock ./

ENV LANG=C.UTF-8 \
   BUNDLE_JOBS=4 \
   BUNDLE_RETRY=3
# BUNDLE_PATH='vendor/bundle'
# <- to bundle only the gems needed from Gemfile into local folder /vendor/bundle

RUN gem install bundler:${BUNDLER_VERSION} --no-document \
   # && bundle config set --without 'development test' \
   && bundle install --quiet \
   && rm -rf /usr/local/bundle/cache/*.gem \
   && find /usr/local/bundle/gems/ -name "*.c" -delete \
   && find /usr/local/bundle/gems/ -name "*.o" -delete

RUN yarn --check-files --silent

COPY . ./

# RUN bundle exec rake assets:precompile

###########################################################################

# FROM ruby:${RUBY_VERSION}

# RUN apk update  && apk add --no-cache libpq netcat-openbsd tzdata\
#    && rm -rf /var/cache/apk/*

# COPY --from=builder  /app /app

# ENTRYPOINT ["./docker-entrypoint.sh"]

# ENV RAILS_ENV=production \
#    NODE_ENV=production \
#    RAILS_LOG_TO_STDOUT=true \
#    RAILS_SERVE_STATIC_FILES=true \
#    BUNDLE_PATH='vendor/bundle'

# WORKDIR /app
# RUN rm -rf node_modules

