# Utilizza l'immagine base Debian Buster
FROM debian:buster

# Aggiorna le repository e installa i pacchetti necessari
RUN apt-get update && apt-get -y install \
	wget \
	curl \
	bash \
	php \
	php-cgi \
	php-mysql \
	php-fpm \
	php-pdo \
	php-gd php-cli \
	php-mbstring \
	redis \
	php-redis \
	&& rm -rf /var/lib/apt/lists/*

# Scarica e installa l'utilità WP-CLI per la gestione di WordPress
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
  && chmod +x wp-cli.phar \
  && mv wp-cli.phar /usr/local/bin/wp

# Copia il file di configurazione www.conf nella directory corretta per PHP-FPM
COPY ./conf/www.conf /etc/php/7.3/fpm/pool.d/

# Crea la cartella per abilitare l'avvio di PHP-FPM
RUN mkdir /run/php

# Copia lo script configure.sh e concede i permessi per eseguirlo
COPY ./tools/configure.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/configure.sh
ENTRYPOINT ["/usr/local/bin/configure.sh"]

# Imposta la directory di lavoro nella cartella HTML
WORKDIR /var/www/html/

# Espone la porta 9000 su cui PHP-FPM ascolterà le richieste
EXPOSE 9000

# Avvia PHP-FPM in foreground e ignora l'opzione daemonize dal file di configurazione (-F)
CMD ["/usr/sbin/php-fpm7.3", "-F"]
