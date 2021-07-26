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
   # && bundle config set deployment 'true' \
   && bundle config set --without 'development test' \
   && bundle install --quiet 

RUN yarn --check-files --silent --production && yarn cache clean

COPY . ./

RUN bundle exec rake assets:precompile


###########################################################################
ARG RUBY_VERSION=3.0.2-alpine
FROM ruby:${RUBY_VERSION}

ARG RAILS_ENV=production

# ARG REDIS_URL=redis://user:tq4hBlYvIvq0uU7hYMOYS6ErQKsSA2N8@redis-13424.c258.us-east-1-4.ec2.cloud.redislabs.com:13424
# ARG POSTGRES_URL=postgres://ortkcbqt:fhSBQrF3Dzl9WWA1FfRIjQmU7u3pBtTd@batyr.db.elephantsql.com/ortkcbqt

RUN apk -U upgrade && apk add --no-cache  libpq tzdata netcat-openbsd \
   && rm -rf /var/cache/apk/*

# -disabled-password doesn't assign a password, so cannot login
RUN adduser --disabled-password app-user
USER app-user

COPY --from=builder --chown=app-user /app /app

# ENTRYPOINT ["./docker-entrypoint.sh"]

ENV RAILS_ENV=$RAILS_ENV \
   RAILS_LOG_TO_STDOUT=true \
   RAILS_SERVE_STATIC_FILES=false  \
   BUNDLE_PATH='vendor/bundle' \
   POSTGRES_URL=$POSTGRES_URL \
   REDIS_URL=$REDIS_URL

WORKDIR /app
RUN rm -rf node_modules tmp/cache tmp/miniprofiler tmp/sockets





