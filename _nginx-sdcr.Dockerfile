FROM nginx:1.21.1-alpine
COPY ./nginx/nginx-sdcr.conf /etc/nginx/conf.d/nginx.conf
COPY ./public/  /usr/share/nginx/html
