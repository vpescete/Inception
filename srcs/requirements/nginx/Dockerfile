FROM alpine:latest

RUN apk update && \
    apk add \
        build-base \
        perl \
        nginx \
        bash && \
    apk cache clean && rm -rf /var/cache/apk/*

RUN mkdir /etc/nginx/ssl
RUN openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
       -out /etc/nginx/ssl/vpescete.crt \
       -keyout /etc/nginx/ssl/vpescete.key \
       -subj "/C=IT/ST=Rome/L=Rome/O=42 School/OU=vpescete/CN=vpescete/"

COPY ./conf/nginx.conf /etc/nginx/conf.d

CMD ["nginx", "-g", "daemon off;"]
