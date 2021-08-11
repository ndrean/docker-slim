FROM nginx:1.21.1-alpine
COPY ./webserver/prod.conf /etc/nginx/conf.d/nginx.conf
COPY ./public /usr/share/nginx/html
RUN rm /var/log/nginx/access.log \ 
   && rm /var/log/nginx/error.log \ 
   && ln -s /dev/stdout /var/log/nginx/access.log \
   && ln -s /dev/stderr /var/log/nginx/error.log

CMD ["nginx", "-g", "daemon off;"]

