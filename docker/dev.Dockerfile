ARG RUBY_VERSION
FROM ruby:${RUBY_VERSION:-3.0.2-alpine}

ARG BUNDLER_VERSION
ARG NODE_ENV
ARG RAILS_ENV

ENV BUNDLER_VERSION=${BUNDLER_VERSION:-2.2.26} \
   RAILS_ENV=${RAILS_ENV:-development} \
   NODE_ENV=${NODE_ENV:-development}
# RAILS_SERVE_STATIC_FILES=true <- default dev

RUN apk -U upgrade && apk add --no-cache \
   postgresql-dev nodejs yarn build-base tzdata curl \
   && rm -rf /var/cache/apk/*

# ENV PATH /app/bin:$PATH
WORKDIR /app

COPY Gemfile Gemfile.lock package.json yarn.lock ./

ENV LANG=C.UTF-8 \
   BUNDLE_JOBS=4 \
   BUNDLE_RETRY=3
# BUNDLE_PATH='vendor/bundle' 

RUN gem install bundler:${BUNDLER_VERSION} --no-document \
   && bundle install --quiet \
   && rm -rf $GEM_HOME/cache/* \
   && rm -rf /usr/local/bundle/cache/*.gem \
   && find /usr/local/bundle/gems/ -name "*.c" -delete \
   && find /usr/local/bundle/gems/ -name "*.o" -delete

RUN yarn --check-files --silent  && yarn cache clean

COPY . ./

# <- need to compile the first time ???????????
# RUN bundle exec rails webpacker:compile assets:clean 
