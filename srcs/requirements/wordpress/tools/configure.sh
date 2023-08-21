#!/bin/sh

# wait for mysql
while ! mariadb -h$MYSQL_HOSTNAME -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE &>/dev/null; do
    sleep 3
done

if [ ! -f "/var/www/html/index.html" ]; then

    # static website
    mv /tmp/domobite/* /var/www/html/

 	# adminer
    wget https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1-mysql-en.php -O /var/www/html/adminer.php &> /dev/null
    wget https://raw.githubusercontent.com/Niyko/Hydra-Dark-Theme-for-Adminer/master/adminer.css -O /var/www/html/adminer.css &> /dev/null

    wp core download --allow-root
    wp config create --dbname=$MYSQL_DATABASE --dbuser=$MYSQL_USER --dbpass=$MYSQL_PASSWORD --dbhost=$MYSQL_HOSTNAME --dbcharset="utf8" --dbcollate="utf8_general_ci" --allow-root
    wp core install --url=$DOMAIN_NAME/wordpress --title=domobite --admin_user=$WP_USER_ADMIN --admin_password=$WP_PWD_ADMIN --admin_email=$WP_EMAIL_ADMIN --skip-email --allow-root
    wp user create $WP_USR $WP_EMAIL --role=author --user_pass=$WP_PWD --allow-root
    wp theme install inspiro --activate --allow-root
fi

echo "Wordpress started on :9000"
/usr/sbin/php-fpm7 -F -R