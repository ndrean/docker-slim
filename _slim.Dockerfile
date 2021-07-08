ARG RUBY_VERSION
FROM ruby:${RUBY_VERSION} AS builder

ARG BUNDLER_VERSION \
   NODE_VERSION \
   NODE_ENV \
   RAILS_ENV

ENV RAILS_ENV=${RAILS_ENV} \
   NODE_ENV=${NODE_ENV} \
   BUNDLER_VERSION=${BUNDLER_VERSION}


RUN apt-get update \
   # && DEBIAN_FRONTEND=noninteractive 
   && apt-get install -y --no-install-recommends \
   # for gems to be compiled
   build-essential \
   # to get desired node version
   curl \
   && apt-get clean \
   && apt-get autoremove
# && rm -rf /var/cache/apt/archives/* \
# && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
# && truncate -s 0 /var/log/*log


RUN curl -sL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash  && \
   curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
   echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list

RUN apt-get  update  \
   # && DEBIAN_FRONTEND=noninteractive 
   && apt-get install -y --no-install-recommends \
   # comm with PG with gem 'pg'
   libpq-dev \ 
   netcat-openbsd \
   # compile assets
   nodejs \
   yarn \
   && apt-get clean \
   && apt-get autoremove
# && rm -rf /var/cache/apt/archives/* \
# && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
# && truncate -s 0 /var/log/*log

WORKDIR /app

COPY Gemfile Gemfile.lock package.json yarn.lock ./

ENV LANG=C.UTF-8 \
   BUNDLE_JOBS=4 \
   BUNDLE_RETRY=3
# BUNDLE_PATH='vendor/bundle'

RUN gem install bundler:${BUNDLER_VERSION} --no-document \
   && bundle config set bin 'true' \
   && bundle install --quiet  \
   && rm -rf /usr/local/bundle/cache/*.gem \
   && find /usr/local/bundle/gems/ -name "*.c" -delete \
   && find /usr/local/bundle/gems/ -name "*.o" -delete

RUN yarn --check-files --silent && yarn cache clean

COPY . ./
