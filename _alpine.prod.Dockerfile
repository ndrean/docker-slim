ARG RUBY_VERSION=3.0.2-alpine
FROM ruby:${RUBY_VERSION:-3.0.1-alpine} AS builder

ARG BUNDLER_VERSION=2.2.26
ARG NODE_ENV=production
ARG RAILS_ENV=production
ARG RAILS_SERVE_STATIC_FILES=false
RUN apk -U upgrade && apk add --no-cache \
   postgresql-dev nodejs yarn build-base tzdata git

ENV PATH /app/bin:$PATH
WORKDIR /app

COPY Gemfile Gemfile.lock ./

ENV LANG=C.UTF-8 \
   BUNDLE_JOBS=4 \
   BUNDLE_RETRY=3 \
   BUNDLE_PATH='vendor/bundle' 

RUN yarn add https://github.com/rails/webpacker.git

RUN gem install bundler:${BUNDLER_VERSION} --no-document \
   # && bundle config set deployment 'true' \
   && bundle config set --without 'development test' \
   && bundle install --quiet 

COPY package.json yarn.lock ./
RUN yarn --check-files --silent --production && yarn cache clean

COPY . ./

RUN bundle exec rails webpacker:compile  assets:clean


###########################################################################
ARG RUBY_VERSION=3.0.2-alpine
FROM ruby:${RUBY_VERSION}

ARG RAILS_ENV=production


RUN apk -U upgrade && apk add --no-cache  libpq tzdata netcat-openbsd curl\
   && rm -rf /var/cache/apk/*

# -disabled-password doesn't assign a password, so cannot login
RUN adduser --disabled-password app-user
USER app-user

COPY --from=builder --chown=app-user /app /app

# ENTRYPOINT ["./docker-entrypoint.sh"]

ENV RAILS_ENV=$RAILS_ENV \
   RAILS_LOG_TO_STDOUT=true \
   RAILS_SERVE_STATIC_FILES=$RAILS_SERVE_STATIC_FILES  \
   BUNDLE_PATH='vendor/bundle'

WORKDIR /app
RUN rm -rf node_modules

# CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
# CMD ["bundle", "exec", "sidekiq", "-C", "config/sidekiq.yml"]
# CMD ["bundle", "exec", "puma", "-p", "28080", "./cable/config.ru"]
# /public





