# Dockerfile per un'immagine Alpine Linux con MariaDB
#
# Questo Dockerfile definisce l'immagine di base utilizzando Alpine Linux 3.13
# e aggiunge il sistema di gestione di database MariaDB e il client MariaDB.
# La porta 3306, utilizzata da MariaDB per le connessioni al database, viene esposta.
# L'immagine include uno script di configurazione chiamato "configure.sh", che verrà eseguito
# come punto di ingresso quando il container viene avviato.

# Usa l'immagine di base Alpine Linux 3.13
FROM alpine:3.13

# Aggiorna e installa il sistema di gestione di database MariaDB e il client MariaDB
RUN apk update && apk upgrade && apk add --no-cache \
        mariadb \
        mariadb-client

# Espone la porta 3306 per le connessioni a MariaDB
EXPOSE 3306

# Copia lo script di configurazione nella directory temporanea del container
COPY conf/configure.sh /tmp/configure.sh

# Imposta lo script di configurazione come punto di ingresso per il container
ENTRYPOINT ["sh", "/tmp/configure.sh"]
