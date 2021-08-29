FROM ndrean/rails-base AS bob
FROM nginx:1.21.1-alpine
# COPY ./webserver/sidecar.conf /etc/nginx/conf.d/default.conf


COPY --from=bob  /app/public  /usr/share/nginx/html
# COPY ./public /usr/share/nginx/html

