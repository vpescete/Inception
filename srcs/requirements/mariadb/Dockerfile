# Utilizza l'immagine base Debian Buster
FROM debian:buster

# Aggiorna le repository e installa i pacchetti necessari
RUN apt-get update
RUN apt-get install -y mariadb-server \
    mariadb-client \
    vim \
    && rm -rf /var/lib/apt/lists/*

# Permette di eseguire il daemon di MySQL
# Crea e reimposta /var/lib/mysql con la proprietà appropriata
# Assicura che /var/run/mysqld (usato per i file socket e di lock) sia scrivibile indipendentemente dall'UID dell'istanza mysqld
RUN mkdir -p /var/run/mysqld \
&& chown -R mysql:mysql /var/run/mysqld \
&& chmod 777 /var/run/mysqld

# Espone la porta 3306
EXPOSE 3306

# Copia il file di configurazione mysqld.conf in diverse directory
# Il file mysqld.conf definisce le impostazioni di configurazione per il server MySQL/MariaDB
COPY ./conf/mysqld.conf ~/my.cnf
COPY ./conf/mysqld.conf /etc/mysql/my.cnf
COPY ./conf/mysqld.conf /etc/my.cnf

# Un file .sql è uno script SQL che contiene comandi per creare, modificare, popolare o interrogare un database.
# Nel nostro caso, il file wordpress.sql contiene probabilmente le definizioni delle tabelle e i dati di un database WordPress.
# Questo file verrà utilizzato per importare la struttura e i dati del database all'interno del container MariaDB.
# Copia lo script configure.sh e il file wordpress.sql nella directory /usr/local/bin del container per poterli eseguire
# Concede il permesso di eseguire + esegue lo script .sh
COPY ./tools/configure.sh /usr/local/bin/
COPY ./conf/wordpress.sql /usr/local/bin/
RUN chmod +x /usr/local/bin/configure.sh
RUN chmod +x /usr/local/bin/wordpress.sql

# Punto di ingresso: esegue lo script configure.sh
# Lo script configure.sh gestisce l'installazione, la configurazione e l'importazione del database MySQL/MariaDB
ENTRYPOINT [ "/usr/local/bin/configure.sh" ]

# Comando per avviare MariaDB e abilitare il database per l'ascolto globale
CMD ["mysqld", "--bind-address=0.0.0.0"]
