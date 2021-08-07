FROM nginx:1.21.1-alpine
COPY ./webserver/prod.conf /etc/nginx/conf.d/nginx.conf
COPY ./public /usr/share/nginx/html
CMD ["nginx", "-g", "daemon off;"]

