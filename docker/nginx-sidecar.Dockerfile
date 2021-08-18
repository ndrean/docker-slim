FROM nginx:1.21.1-alpine
# COPY ./webserver/sidecar.conf /etc/nginx/conf.d/default.conf

COPY ./public /usr/share/nginx/html

RUN ln -sf /dev/stdout /var/log/nginx/access.log && ln -sf /dev/stdout /var/log/nginx/error.log

