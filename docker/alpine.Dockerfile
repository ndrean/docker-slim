ARG RUBY_VERSION
FROM ruby:${RUBY_VERSION:-3.0.2-alpine} AS builder

ARG BUNDLER_VERSION
ARG NODE_ENV
ARG RAILS_ENV
ARG RAILS_LOG_TO_STDOUT=true

RUN apk -U upgrade && apk add --no-cache \
   postgresql-dev nodejs yarn build-base

ENV PATH /app/bin:$PATH
WORKDIR /app

COPY  Gemfile Gemfile.lock  /app/

ENV LANG=C.UTF-8 \
   BUNDLE_JOBS=4 \
   BUNDLE_RETRY=3 \
   BUNDLE_PATH='vendor/bundle' 

RUN gem install bundler:${BUNDLER_VERSION} --no-document \
   && bundle config set --without 'development test' \
   && bundle install --quiet 

COPY  package.json yarn.lock /app/
RUN   yarn --check-files --silent --production && yarn cache clean

COPY . ./

RUN bundle exec rails webpacker:compile assets:clean

###########################################################################
ARG RUBY_VERSION
FROM ruby:${RUBY_VERSION}

ARG RAILS_ENV
ARG RAILS_LOG_TO_STDOUT

RUN apk -U upgrade && apk add --no-cache  libpq tzdata netcat-openbsd curl \
   && rm -rf /var/cache/apk/* \
   && adduser --disabled-password app-user
# -disabled-password doesn't assign a password, so cannot login

USER app-user

COPY --from=builder --chown=app-user /app /app
# COPY --from=builder  /app /app

ENV RAILS_ENV=$RAILS_ENV \
   RAILS_LOG_TO_STDOUT=$RAILS_LOG_TO_STDOUT \
   BUNDLE_PATH='vendor/bundle'

WORKDIR /app

RUN rm -rf node_modules




