FROM nginx:1.21.1-alpine
# COPY ./webserver/split.conf /etc/nginx/conf.d/default.conf
RUN rm /var/log/nginx/access.log \ 
   && rm /var/log/nginx/error.log \ 
   && ln -s /dev/stdout /var/log/nginx/access.log \
   && ln -s /dev/stderr /var/log/nginx/error.log

COPY ./public /usr/share/nginx/html