FROM alpine:latest

RUN apk update && \
    apk add \
        build-base \
        perl && \
    apk cache clean && rm -rf /var/cache/apk/*

COPY pcre-8.45.tar.gz .
RUN tar -xvf pcre-8.45.tar.gz && rm pcre-8.45.tar.gz
RUN cd pcre-8.45 && \
    ./configure \
        --enable-static \
        --disable-shared && \
    make && make install
RUN rm -rf /pcre-8.45

COPY openssl-3.1.2.tar.gz .
RUN tar -xvf openssl-3.1.2.tar.gz && rm openssl-3.1.2.tar.gz
RUN cd openssl-3.1.2 && \
    ./config && \
    make && make install
RUN rm -rf /openssl-3.1.2

COPY nginx-1.25.1.tar.gz .
RUN tar -xvf nginx-1.25.1.tar.gz && rm nginx-1.25.1.tar.gz
RUN cd nginx-1.25.1 && \
    ./configure \
        --sbin-path=/usr/bin/nginx \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \
        --http-log-path=/var/log/nginx/access.log \
        --with-pcre \
        --pid-path=/var/run/nginx.pid \
        --with-http_ssl_module \
        --with-openssl=<path> && \
    make && make install
RUN rm -rf /nginx-1.25.1

CMD ["nginx", "-g", "daemon off;"]