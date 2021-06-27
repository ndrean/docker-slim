ARG RUBY_VERSION
FROM ruby:${RUBY_VERSION:-3.0.1-alpine} AS builder

ARG BUNDLER_VERSION
ARG NODE_ENV
ARG RAILS_ENV

ENV RAILS_ENV=${RAILS_ENV:-production} \
   NODE_ENV=${NODE_ENV:-production} \
   BUNDLER_VERSION=${BUNDLER_VERSION:-2.2.21}

RUN apk -U upgrade && apk add --no-cache \
   postgresql-dev nodejs yarn build-base tzdata

WORKDIR /app

COPY Gemfile Gemfile.lock package.json yarn.lock ./

ENV LANG=C.UTF-8 \
   BUNDLE_JOBS=4 \
   BUNDLE_RETRY=3 \
   BUNDLE_PATH='vendor/bundle'
# <- to bundle only the gems needed from Gemfile into local folder /vendor/bundle

RUN gem install bundler:${BUNDLER_VERSION} --no-document \
   && bundle config set --without 'development test' \
   && bundle install --quiet 

RUN yarn --check-files --silent

COPY . ./

RUN bundle exec rake assets:precompile


###########################################################################

FROM ruby:${RUBY_VERSION}

ARG RAILS_ENV
ARG NODE_ENV

RUN apk -U upgrade && apk add libpq netcat-openbsd tzdata\
   && rm -rf /var/cache/apk/*

COPY --from=builder  /app /app

# ENTRYPOINT ["./docker-entrypoint.sh"]

ENV RAILS_ENV=$RAILS_ENV \
   NODE_ENV=$NODE_ENV \
   RAILS_LOG_TO_STDOUT=true \
   RAILS_SERVE_STATIC_FILES=true \
   BUNDLE_PATH='vendor/bundle'

WORKDIR /app
RUN rm -rf node_modules

