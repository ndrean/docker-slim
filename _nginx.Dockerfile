# ARG RUBY_VERSION
# FROM ruby:${RUBY_VERSION:-3.0.1-alpine} AS builder

# ARG BUNDLER_VERSION=2.2.14
# ARG NODE_ENV=production
# ARG RAILS_ENV=production

# RUN apk -U upgrade && apk add --no-cache \
#    postgresql-dev nodejs yarn build-base tzdata

# ENV PATH /app/bin:$PATH
# WORKDIR /app

# COPY Gemfile Gemfile.lock package.json yarn.lock ./

# ENV LANG=C.UTF-8 \
#    BUNDLE_JOBS=4 \
#    BUNDLE_RETRY=3 \
#    BUNDLE_PATH='vendor/bundle' 

# RUN gem install bundler:${BUNDLER_VERSION} --no-document \
#    # && bundle config set deployment 'true' \
#    && bundle config set --without 'development test' \
#    && bundle install --quiet 

# RUN yarn --check-files --silent --production && yarn cache clean

# COPY . ./

# RUN bundle exec rake assets:precompile

#######################################

FROM nginx:1.21.1-alpine
COPY ./webserver/prod.conf /etc/nginx/conf.d/nginx.conf

# RUN adduser --disabled-password app-user
# USER app-user
# COPY --from=builder --chown=app-user ./public/  /usr/share/nginx/html

COPY ./public /usr/share/nginx/html

CMD ["nginx", "-g", "daemon off;"]

