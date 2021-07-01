ARG RUBY_VERSION=3.0.1-alpine
FROM ruby:${RUBY_VERSION:-3.0.1-alpine} AS builder

ARG BUNDLER_VERSION=2.2.21
ARG NODE_ENV=production
ARG RAILS_ENV=production

RUN apk -U upgrade && apk add --no-cache \
   postgresql-dev nodejs yarn build-base tzdata

WORKDIR /app

COPY Gemfile Gemfile.lock package.json yarn.lock ./

ENV LANG=C.UTF-8 \
   BUNDLE_JOBS=4 \
   BUNDLE_RETRY=3 \
   BUNDLE_PATH='vendor/bundle'

RUN gem install bundler:${BUNDLER_VERSION} --no-document \
   && bundle config set --without 'development test' \
   && bundle install --quiet 

RUN yarn --check-files --silent --production

COPY . ./

RUN bundle exec rake assets:precompile


###########################################################################
ARG RUBY_VERSION=3.0.1-alpine
FROM ruby:${RUBY_VERSION}

ARG RAILS_ENV=production
ARG NODE_ENV=production

RUN apk -U upgrade && apk add --no-cache  libpq tzdata \
   && rm -rf /var/cache/apk/*

# -D --disabled-password, don't assign a password, so cannot login
RUN adduser -D app-user
USER app-user

COPY --from=builder --chown=app-user /app /app

# ENTRYPOINT ["./docker-entrypoint.sh"]

ENV RAILS_ENV=$RAILS_ENV \
   NODE_ENV=$NODE_ENV \
   RAILS_LOG_TO_STDOUT=true \
   RAILS_SERVE_STATIC_FILES=true  \
   BUNDLE_PATH='vendor/bundle'

WORKDIR /app
RUN rm -rf node_modules





