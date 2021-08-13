FROM builder

ARG RAILS_ENV
ARG NODE_ENV
ARG RAILS_SERVE_STATIC_FILES

RUN apk -U upgrade && apk add --no-cache  libpq tzdata netcat-openbsd \
   && rm -rf /var/cache/apk/*

RUN rm -rf node_modules tmp/cache tmp/sockets 
# <--- moved from the end !!!!

# -disabled-password doesn't assign a password, so cannot login
RUN adduser --disabled-password app-user
USER app-user

COPY --from=builder --chown=app-user /app /app
# COPY --from=builder  /app /app

ENV RAILS_ENV=$RAILS_ENV \
   RAILS_LOG_TO_STDOUT=true \
   RAILS_SERVE_STATIC_FILES=RAILS_SERVE_STATIC_FILES \
   BUNDLE_PATH='vendor/bundle'

WORKDIR /app






