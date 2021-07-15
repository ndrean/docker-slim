FROM nginx:1.21.1-alpine
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./public /usr/share/nginx/html
CMD [ "nginx","-g","daemon off;"]