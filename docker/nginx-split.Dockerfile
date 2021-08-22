FROM ndrean/rails-base AS bob

FROM nginx:1.21.1-alpine


COPY --from=bob  /app/public  /usr/share/nginx/html
