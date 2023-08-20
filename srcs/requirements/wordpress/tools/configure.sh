#!/bin/sh

# Script di configurazione per l'avvio di WordPress

# Aspetta che il server MySQL (MariaDB) sia pronto
while ! mariadb -h$MYSQL_HOST -u$WP_DB_USR -p$WP_DB_PWD $WP_DB_NAME &>/dev/null; do
    sleep 3
done

# Verifica se il file "index.html" esiste nella directory di lavoro
if [ ! -f "/var/www/html/index.html" ]; then

    # Sposta il sito web statico nella directory di lavoro
    mv /tmp/index.html /var/www/html/

    # Installa e configura WordPress utilizzando WP-CLI
    wp core download --allow-root
    wp config create --dbname=$WP_DB_NAME --dbuser=$WP_DB_USR --dbpass=$WP_DB_PWD --dbhost=$MYSQL_HOST --dbcharset="utf8" --dbcollate="utf8_general_ci" --allow-root
    wp core install --url=$DOMAIN_NAME/wordpress --title=$WP_TITLE --admin_user=$WP_ADMIN_USR --admin_password=$WP_ADMIN_PWD --admin_email=$WP_ADMIN_EMAIL --skip-email --allow-root --https
    wp user create $WP_USR $WP_EMAIL --role=author --user_pass=$WP_PWD --allow-root
    wp theme install inspiro --activate --allow-root

fi

# Avvia PHP-FPM
echo "Wordpress started on :9000"
/usr/sbin/php-fpm7 -F -R
