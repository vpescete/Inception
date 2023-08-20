#!/bin/sh

# Script di configurazione e avvio di MariaDB

# Verifica se la directory "/run/mysqld" esiste, altrimenti crea la directory e assegna i permessi
if [ ! -d "/run/mysqld" ]; then
    mkdir -p /run/mysqld
    chown -R mysql:mysql /run/mysqld
fi

# Verifica se la directory "/var/lib/mysql/mysql" non esiste, quindi inizializza il database
if [ ! -d "/var/lib/mysql/mysql" ]; then

    # Assegna i permessi alla directory del database
    chown -R mysql:mysql /var/lib/mysql

    # Inizializza il database MariaDB
    mysql_install_db --basedir=/usr --datadir=/var/lib/mysql --user=mysql --rpm > /dev/null

    tfile=`mktemp`
    if [ ! -f "$tfile" ]; then
        return 1
    fi

# Configurazione iniziale del database
# Questa sezione del codice definisce una serie di istruzioni SQL che verranno eseguite
# per configurare il database MariaDB iniziale. Gli step includono:
# - Utilizzo del database "mysql"
# - Aggiornamento dei privilegi
# - Rimozione di utenti vuoti
# - Eliminazione del database di test predefinito
# - Rimozione degli utenti "root" non necessari per le connessioni remote
# - Modifica della password dell'utente "root" locale
# - Creazione del database specificato ($WP_DB_NAME) con un certo set di caratteri
# - Creazione di un utente specificato ($WP_DB_USR) con la password specificata
# - Concessione di tutti i privilegi sull'utente e il database appena creati
# - Aggiornamento dei privilegi
cat << EOF > $tfile
USE mysql;
FLUSH PRIVILEGES;

DELETE FROM	mysql.user WHERE User='';
DROP DATABASE test;
DELETE FROM mysql.db WHERE Db='test';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');

ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PWD';

CREATE DATABASE $WP_DB_NAME CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER '$WP_DB_USR'@'%' IDENTIFIED by '$WP_DB_PWD';
GRANT ALL PRIVILEGES ON $WP_DB_NAME.* TO '$WP_DB_USR'@'%';

FLUSH PRIVILEGES;
EOF

    # Esegui il file di configurazione SQL appena creato
    /usr/bin/mysqld --user=mysql --bootstrap < $tfile
    rm -f $tfile
fi

# Abilita le connessioni remote a MariaDB
sed -i "s|skip-networking|# skip-networking|g" /etc/my.cnf.d/mariadb-server.cnf
sed -i "s|.*bind-address\s*=.*|bind-address=0.0.0.0|g" /etc/my.cnf.d/mariadb-server.cnf

# Avvia il server MariaDB
exec /usr/bin/mysqld --user=mysql --console
