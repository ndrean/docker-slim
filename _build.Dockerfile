ARG RUBY_VERSION=3.0.2-alpine
FROM ruby:${RUBY_VERSION:-3.0.1-alpine} AS builder

ARG BUNDLER_VERSION=2.2.24
ARG NODE_ENV=production
ARG RAILS_ENV=production

RUN apk -U upgrade && apk add --no-cache \
   postgresql-dev nodejs yarn build-base tzdata

ENV PATH /app/bin:$PATH
WORKDIR /app

COPY Gemfile Gemfile.lock package.json yarn.lock ./

ENV LANG=C.UTF-8 \
   BUNDLE_JOBS=4 \
   BUNDLE_RETRY=3 \
   BUNDLE_PATH='vendor/bundle' 

RUN gem install bundler:${BUNDLER_VERSION} --no-document \
   && bundle config set --without 'development test' \
   && bundle install --quiet 

RUN yarn --check-files --silent --production && yarn cache clean

COPY . ./

RUN bundle exec rails assets:precompile