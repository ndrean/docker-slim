FROM nginx:1.21.1-alpine
# COPY ./webserver/split.conf /etc/nginx/conf.d/default.conf
COPY ./public /usr/share/nginx/html