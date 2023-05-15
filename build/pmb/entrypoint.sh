#!/bin/bash

function wait_for_db {

    echo -n "Waiting for database connection: "
	until nc -z -w1 $MYSQL_HOST 3306
	do
	  # wait for 0.5 seconds before check again
	  echo -n "."
	  sleep 0.5
	done
	echo " done"
}

function initialiser_parametres {
	mkdir -p /etc/pmb
	touch /etc/pmb/db_param.inc.php
	chown www-data:www-data /etc/pmb/db_param.inc.php
	ln -s /etc/pmb/db_param.inc.php /var/www/html/pmb/includes/db_param.inc.php
    ln -s /etc/pmb/db_param.inc.php /var/www/html/pmb/opac_css/includes/opac_db_param.inc.php
}

[ ! -f /var/www/html/pmb/includes/db_param.inc.php ] && initialiser_parametres

wait_for_db
service php7.4-fpm start
nginx -g 'daemon off;'
