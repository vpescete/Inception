FROM alpine:latest

RUN apk update && \
    apk add \
        build-base \
        perl \
        nginx \
        bash && \
    apk cache clean && rm -rf /var/cache/apk/*

# Creazione della cartella di montaggio
RUN mkdir -p /etc/nginx/conf.d
RUN mkdir -p /etc/nginx/html

COPY ../../html /etc/nginx/html

COPY conf/mynginx.conf /etc/nginx/conf.d/nginx.conf

CMD ["nginx", "-g", "daemon off;"]
