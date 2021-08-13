FROM ndrean/builder as builder

FROM nginx:1.21.1-alpine

COPY --from=builder  ./app/public  /usr/share/nginx/html
