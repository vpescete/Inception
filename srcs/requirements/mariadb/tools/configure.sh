#!/bin/sh

# Installa e configura MySQL
mysql_install_db

# Avvia il servizio MySQL
/etc/init.d/mysql start

# Verifica se il database esiste
if [ -d "/var/lib/mysql/$WP_DATABASE" ]; then
	echo "Il database esiste già."
else
	# Imposta l'opzione root per impedire la connessione senza password di root

	mysql_secure_installation << _EOF_
	Y
	123456rootDB
	123456rootDB
	Y
	n
	Y
	Y

_EOF_

	# Aggiungi un utente root su 127.0.0.1 per consentire la connessione remota
	# FLUSH PRIVILEGES permette alle tue tabelle SQL di essere aggiornate automaticamente quando le modifichi
	# mysql -uroot avvia il client mysql da linea di comando
	echo "GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '$WP_ROOT_PWD'; FLUSH PRIVILEGES;" | mysql -uroot

	# Crea il database e l'utente nel database per WordPress
	echo "CREATE DATABASE IF NOT EXISTS $WP_DATABASE; GRANT ALL ON $WP_DATABASE.* TO '$WP_USER'@'%' IDENTIFIED BY '$WP_PWD'; FLUSH PRIVILEGES;" | mysql -u root

	# Importa il database nella linea di comando MySQL
	mysql -uroot -p$WP_ROOT_PWD $WP_DATABASE < /usr/local/bin/wordpress.sql
fi

# Arresta il servizio MySQL
/etc/init.d/mysql stop

# Esegui il comando passato agli argomenti dello script
exec "$@"
