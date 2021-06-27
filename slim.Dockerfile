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
   && rm -rf /var/cache/apt/archives/* \
   && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
   && truncate -s 0 /var/log/*log


RUN curl -sL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash  && \
   curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
   echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list

RUN apt-get  update  \
   # && DEBIAN_FRONTEND=noninteractive 
   && apt-get install -y --no-install-recommends \
   # comm with PG with gem 'pg'
   libpq-dev \ 
   # compile assets
   nodejs \
   yarn \
   && apt-get clean \
   && rm -rf /var/cache/apt/archives/* \
   && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
   && truncate -s 0 /var/log/*log


# RUN mkdir -p /app
WORKDIR /app

COPY Gemfile Gemfile.lock package.json yarn.lock ./

ENV LANG=C.UTF-8 \
   BUNDLE_JOBS=4 \
   BUNDLE_RETRY=3 \
   BUNDLE_PATH='vendor/bundle'

RUN gem install bundler:${BUNDLER_VERSION} --no-document \
   && bundle config set --without 'development test' \
   && bundle install --quiet \
   && rm -rf /usr/local/bundle/cache/*.gem \
   && find /usr/local/bundle/gems/ -name "*.c" -delete \
   && find /usr/local/bundle/gems/ -name "*.o" -delete

RUN yarn --check-files --silent

COPY . ./

RUN bundle exec rake assets:precompile
# && rm -rf node_modules tmp/cache app/assets vendor/assets lib/assets spec

# ENV RAILS_SERVE_STATIC_FILES true

###########################################

FROM ruby:${RUBY_VERSION}

RUN apt-get  update  \
   && apt-get install -y --no-install-recommends \
   # detect when services inside containers are up and running
   netcat-openbsd \
   # communicate with PG with gem 'pg'
   libpq-dev \
   # postgresql-client \
   && apt-get clean \
   && rm -rf /var/cache/apt/archives/* \
   && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
   && truncate -s 0 /var/log/*log
# && useradd -u 1000 -Um rails

#<- we copy the host bundle folder if not flag BUNBLER_PATH='vendor/bundle' in which case it's local
# COPY --from=builder /usr/local/bundle/ /usr/local/bundle/

COPY --from=builder  /app /app

ENTRYPOINT ["./docker-entrypoint.sh"]

ENV RAILS_ENV=production \
   NODE_ENV=production \
   RAILS_LOG_TO_STDOUT=true \
   RAILS_SERVE_STATIC_FILES=true \
   BUNDLE_PATH='vendor/bundle'

WORKDIR /app
# RUN rm -rf node_modules tmp/cache  /vendor lib/assets

EXPOSE 3000

