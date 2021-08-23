ARG RUBY_VERSION
FROM ruby:${RUBY_VERSION:-3.0.2-alpine} AS builder

ARG BUNDLER_VERSION=2.2.26
ARG NODE_ENV=development
ARG RAILS_ENV=development

ENV RAILS_ENV=${RAILS_ENV:-development} \
   NODE_ENV=${NODE_ENV:-development} \
   BUNDLER_VERSION=${BUNDLER_VERSION:-2.2.26}

RUN apk update && apk add --no-cache \
   postgresql-dev nodejs yarn build-base tzdata curl netcat-openbsd \
   && rm -rf /var/cache/apk/*

WORKDIR /app

COPY Gemfile Gemfile.lock package.json yarn.lock ./

ENV LANG=C.UTF-8 \
   BUNDLE_JOBS=4 \
   BUNDLE_RETRY=3
# BUNDLE_PATH='vendor/bundle'
# <- to bundle only the gems needed from Gemfile into local folder /vendor/bundle

RUN gem install bundler:$BUNDLER_VERSION --no-document \
   # && bundle config set --without 'development test' \
   && bundle install --quiet \
   && rm -rf /usr/local/bundle/cache/*.gem \
   && find /usr/local/bundle/gems/ -name "*.c" -delete \
   && find /usr/local/bundle/gems/ -name "*.o" -delete

RUN yarn --check-files --silent && yarn cache clean

COPY . ./
