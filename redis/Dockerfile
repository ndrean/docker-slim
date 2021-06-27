FROM redis:6.2.4-alpine
COPY ./config/redis.conf /usr/local/etc/redis/redis.conf
ENTRYPOINT [ "redis-server", "/usr/local/etc/redis/redis.conf" ]