#!/bin/sh

# Questo è uno script di shell che automatizza il processo di download e configurazione di WordPress.
# Si basa su variabili d'ambiente definite in un file .env (nella directory superiore).

# Carica le variabili d'ambiente da un file .env (nella directory superiore)
source ../../../.env

# Verifica se il file wp-config.php esiste già
if [ -f ./wp-config.php ]; then
    echo "WordPress è già stato scaricato in precedenza."
else
    # Scarica l'archivio compresso di WordPress dalla rete
	wget http://wordpress.org/latest.tar.gz

    # Estrai il contenuto dell'archivio compresso
	tar xfz latest.tar.gz

    # Sposta i file di WordPress nella directory corrente
	mv wordpress/* .

    # Elimina l'archivio compresso e la directory temporanea
	rm -rf latest.tar.gz
	rm -rf wordpress

	# Sostituisci le variabili nei file di configurazione con i valori dell'ambiente
    # Queste variabili sono definite nel file .env
	sed -i "s/username_here/$WP_USER/g" wp-config-sample.php
	sed -i "s/password_here/$WP_PWD/g" wp-config-sample.php
	sed -i "s/localhost/$WP_HOSTNAME/g" wp-config-sample.php
	sed -i "s/database_name_here/$WP_DATABASE/g" wp-config-sample.php

    # Crea una copia del file di configurazione rinominandolo in wp-config.php
	cp wp-config-sample.php wp-config.php
fi

# Avvia il comando passato come argomenti
# Questa riga eseguirà il comando specificato quando si avvia il container basato su questo script
exec "$@"
