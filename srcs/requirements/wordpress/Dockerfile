FROM alpine:3.13

# Aggiunge un utente "nginx" e copia i file di configurazione di PHP-FPM
RUN apk update && apk upgrade && \
		apk add --no-cache \
		wget \
		tar \
		mariadb-client \
		redis \
		php7 \
		php7-fpm \
		php7-bcmath \
		php7-bz2 \
		php7-calendar \
		php7-ctype \
		php7-curl \
		php7-dom \
		php7-exif \
		php7-fileinfo \
		php7-gd \
		php7-gmagick \
		php7-gmp \
		php7-iconv \
		php7-imap \
		php7-intl \
		php7-json \
		php7-mbstring \
		php7-mcrypt \
		php7-memcache \
		php7-mysqli \
		php7-mysqlnd \
		php7-openssl \
		php7-pcntl \
		php7-pdo \
		php7-pdo_mysql \
		php7-pdo_pgsql \
		php7-pdo_sqlite \
		php7-pgsql \
		php7-phar \
		php7-posix \
		php7-session \
		php7-shmop \
		php7-simplexml \
		php7-soap \
		php7-sockets \
		php7-sodium \
		php7-sqlite3 \
		php7-sysvsem \
		php7-sysvshm \
		php7-tokenizer \
		php7-xml \
		php7-xmlreader \
		php7-xmlwriter \
		php7-xsl \
		php7-zip \
		php7-zlib

# adding nginx user
RUN adduser -S nginx && addgroup -S nginx

# Copia il file di configurazione specifico del pool PHP-FPM
# Il file www.conf è utilizzato per definire le impostazioni del pool PHP-FPM.
# Un pool rappresenta un gruppo di processi PHP-FPM che gestisce le richieste
# per un'applicazione specifica. Questo file contiene parametri come il numero
# massimo di processi, limiti di risorse, utenti e gruppi associati ai processi PHP, ecc.
COPY conf/www.conf /etc/php7/php-fpm.d/www.conf

# Copia il file di configurazione principale di PHP-FPM
# Il file php-fpm.conf è il file di configurazione globale per l'intero
# processo PHP-FPM. Contiene impostazioni globali che influenzano tutti i pool
# PHP-FPM. Queste impostazioni includono parametri come il numero massimo di processi globali,
# il limite delle risorse, le direttive di log, le impostazioni di controllo,
# le connessioni di rete e altro. Questo file definisce il comportamento globale
# di PHP-FPM all'interno del server.
COPY conf/php-fpm.conf /etc/php7/php-fpm.conf


# Copia un file HTML statico per il sito
COPY conf/index.html /tmp/index.html

# WP-CLI (WordPress Command Line Interface) è uno strumento da riga di comando
# progettato per semplificare la gestione di WordPress attraverso comandi
# da eseguire nella shell. Fornisce una vasta gamma di funzionalità per
# gestire siti, temi, plugin, utenti e altro senza dover utilizzare
# l'interfaccia utente del pannello di amministrazione di WordPress.
#
# L'installazione di WP-CLI qui consente di utilizzare questo strumento
# all'interno del container Docker per automatizzare compiti di gestione
# di WordPress come installazione, aggiornamento e configurazione.
# WP-CLI può essere utilizzato per creare script automatizzati o per
# interagire con WordPress in ambienti di sviluppo e produzione.
#
# Installa WP-CLI (WordPress Command Line Interface)
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN cp wp-cli.phar /usr/bin/wp

# Imposta la directory di lavoro e copia uno script di configurazione
WORKDIR /var/www/html/wordpress
COPY tools/configure.sh /tmp/configure.sh

# Punto di ingresso per l'esecuzione dello script di configurazione
ENTRYPOINT [ "sh", "/tmp/configure.sh" ]