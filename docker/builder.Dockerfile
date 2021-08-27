ARG   RUBY_VERSION
FROM  ruby:${RUBY_VERSION:-3.0.2-alpine}

ARG   BUNDLER_VERSION
ARG   NODE_ENV
ARG   RAILS_ENV

ENV   BUNDLER_VERSION=${BUNDLER_VERSION} \
   RAILS_ENV=${RAILS_ENV} \
   NODE_ENV=${NODE_ENV}

RUN   apk -U upgrade && apk add --no-cache \
   postgresql-dev nodejs yarn build-base tzdata curl git

ENV   PATH /app/bin:$PATH
WORKDIR /app

COPY  Gemfile Gemfile.lock  ./
RUN   yarn add https://github.com/rails/webpacker.git

ENV   LANG=C.UTF-8 BUNDLE_JOBS=4 BUNDLE_RETRY=3 BUNDLE_PATH='vendor/bundle' 

RUN   gem install bundler:${BUNDLER_VERSION} --no-document \
   && bundle config set --without 'development test' \
   && bundle install --quiet \
   && rm -rf $GEM_HOME/cache/*

COPY  package.json yarn.lock ./
RUN   bundle exec rails webpacker:install
RUN   yarn --check-files --silent --production && yarn cache clean

COPY  . ./

RUN   bundle exec rails webpacker:compile assets:clean