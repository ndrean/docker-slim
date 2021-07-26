FROM nginx:1.21.1-alpine
# COPY ./webserver/split.conf /etc/nginx/conf.d/default.conf

# RUN adduser --disabled-password app-user
# USER app-user
# COPY --from=builder --chown=app-user ./public/  /usr/share/nginx/html

COPY ./public /usr/share/nginx/html

# RUN ln -sf /dev/stdout /var/log/nginx/access.log && ln -sf /dev/stdout /var/log/nginx/error.log