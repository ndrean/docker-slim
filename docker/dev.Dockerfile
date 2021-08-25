ARG RUBY_VERSION
FROM ruby:${RUBY_VERSION:-3.0.2-alpine}

ARG BUNDLER_VERSION=2.2.26
ARG NODE_ENV=development
ARG RAILS_ENV=development

ENV BUNDLER_VERSION=${BUNDLER_VERSION} \
   RAILS_ENV=${RAILS_ENV} \
   NODE_ENV=${NODE_ENV}

RUN apk -U upgrade && apk add --no-cache \
   postgresql-dev nodejs yarn build-base tzdata curl git openssl \ 
   && rm -rf /var/cache/apk/*

# ENV PATH /app/bin:$PATH
WORKDIR /app

COPY Gemfile Gemfile.lock ./

ENV LANG=C.UTF-8 \
   BUNDLE_JOBS=4 \
   BUNDLE_RETRY=3
# BUNDLE_PATH='vendor/bundle' 

RUN yarn add webpacker@https://github.com/rails/webpacker.git

RUN gem install bundler:${BUNDLER_VERSION} --no-document \
   && bundle install --quiet
# && rm -rf $GEM_HOME/cache/* \
# && rm -rf /usr/local/bundle/cache/*.gem \
# && find /usr/local/bundle/gems/ -name "*.c" -delete \
# && find /usr/local/bundle/gems/ -name "*.o" -delete

COPY package.json yarn.lock ./
RUN bundle exec rails webpacker:install
RUN yarn add react react-dom @babel/preset-react postcss-preset-env postcss-flexbugs-fixes postcss postcss-loader
RUN yarn 
# --check-files --silent  && yarn cache clean

COPY . ./
