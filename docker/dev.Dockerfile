ARG RUBY_VERSION
FROM ruby:${RUBY_VERSION:-3.0.2-alpine}

ARG BUNDLER_VERSION
ARG NODE_ENV
ARG RAILS_ENV

ENV BUNDLER_VERSION=${BUNDLER_VERSION:-2.2.26}
ENV   RAILS_ENV=${RAILS_ENV:-development}
ENV   NODE_ENV=${NODE_ENV:-development}

RUN apk -U upgrade && apk add --no-cache postgresql-dev nodejs yarn build-base tzdata openssh curl git  \ 
   && rm -rf /var/cache/apk/*

WORKDIR /app

COPY Gemfile Gemfile.lock ./

ENV LANG=C.UTF-8 BUNDLE_JOBS=4 BUNDLE_RETRY=3
# BUNDLE_PATH='vendor/bundle' 

RUN yarn add https://github.com/rails/webpacker.git

RUN gem install bundler:${BUNDLER_VERSION} --no-document \
   && bundle install --quiet
# && rm -rf $GEM_HOME/cache/* \
# && rm -rf /usr/local/bundle/cache/*.gem \
# && find /usr/local/bundle/gems/ -name "*.c" -delete \
# && find /usr/local/bundle/gems/ -name "*.o" -delete

COPY package.json yarn.lock ./
# RUN yarn add react react-dom @babel/preset-react
# RUN yarn add @rails/webpacker@6.0.0-rc.2 --exact
RUN bundle exec rails webpacker:install
RUN yarn install
# --check-files --silent  && yarn cache clean


COPY . ./