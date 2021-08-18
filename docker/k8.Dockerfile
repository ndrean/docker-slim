
FROM alpine:3


RUN apk -U upgrade && apk add --no-cache  curl \
   && rm -rf /var/cache/apk/* \
   && curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl \
   && chmod +x ./kubectl \
   && mv ./kubectl /usr/local/bin/kubectl

CMD ["kubectl","proxy"]




