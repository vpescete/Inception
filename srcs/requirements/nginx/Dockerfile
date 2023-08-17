FROM debian:buster

RUN apt-get update && \
    apt-get install -y \
        build-essential \
        perl \
        nginx \
        bash \
        openssl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY ./conf/nginx.conf /etc/nginx/conf.d

RUN mkdir /etc/nginx/ssl
RUN openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
       -out /etc/nginx/ssl/vpescete.crt \
       -keyout /etc/nginx/ssl/vpescete.key \
       -subj "/C=IT/ST=IT/L=CiRomety/O=42/CN=42"

CMD ["nginx", "-g", "daemon off;"]
