FROM debian:bullseye-slim

ARG PMB_VERSION
ARG PMB_URL

ENV PMB_VERSION=$PMB_VERSION
ENV DEBIAN_FRONTEND noninteractive

ARG PHP_VERSION_MOLECULE=7.4
ARG PHP_VERSION=php${PHP_VERSION_MOLECULE}
ARG PHP_DIR=php/${PHP_VERSION_MOLECULE}

WORKDIR /var/www/html

RUN set -x ; \
    apt-get -y update ; \
    apt-get -y --no-install-recommends  install \
      ca-certificates \
      gnupg2 \
      vim.tiny less \
      wget \
      curl \
      ncat \
      unzip \
      nginx \
      ssl-cert \
      php-pear \
      ${PHP_VERSION}-fpm \
      ${PHP_VERSION}-mysql \
      ${PHP_VERSION}-cgi \
      ${PHP_VERSION}-mbstring \
      ${PHP_VERSION}-gd \
      ${PHP_VERSION}-xsl \
      ${PHP_VERSION}-curl \
      ${PHP_VERSION}-intl \
      ${PHP_VERSION}-soap \
      ${PHP_VERSION}-zip \
      ${PHP_VERSION}-bz2 \
      ${PHP_VERSION}-sqlite3 \
      ${PHP_VERSION}-xml \
      ${PHP_VERSION}-xmlrpc \
      php-cas php-imagick php-ldap ; \
    rm -fr /var/run/apt/

RUN set -x ; \
    wget $PMB_URL ; \
    unzip pmb7*.zip ; rm pmb7*.zip ; chown -R www-data:www-data /var/www/html

ADD default /etc/nginx/sites-available/

RUN set -x ; \
    sed -i s/'max_execution_time = 30'/'max_execution_time = 3600'/ /etc/${PHP_DIR}/fpm/php.ini ; \
    sed -i s/'upload_max_filesize = 2M'/'upload_max_filesize = 1G'/ /etc/${PHP_DIR}/fpm/php.ini ; \
    sed -i s/'memory_limit = 128M'/'memory_limit = 256M'/ /etc/${PHP_DIR}/fpm/php.ini ; \
    sed -i s/'post_max_size = 8M'/'post_max_size = 1G'/ /etc/${PHP_DIR}/fpm/php.ini ; \
    sed -i s/';date.timezone ='/'date.timezone = Europe\/Paris'/ /etc/${PHP_DIR}/fpm/php.ini ; \
    sed -i s/';max_input_vars = 1000'/'max_input_vars = 100000'/ /etc/${PHP_DIR}/fpm/php.ini ; \
    sed -i s/'index.nginx-debian.html'/'index.php'/ /etc/nginx/sites-available/default ; \
    sed -i s/'server_name _;'/"server_name _;\n\n\tlocation ~ \\.php$ {\n\t\tinclude snippets\/fastcgi-php.conf;\n\t\tfastcgi_pass unix:\/var\/run\/php\/php${PHP_VERSION_MOLECULE}-fpm.sock;\n\t}"/ /etc/nginx/sites-available/default

ADD index.html /var/www/html/

ADD entrypoint.sh /usr/local/bin/
EXPOSE 8080
VOLUME ["/etc/pmb"]
CMD ["bash", "/usr/local/bin/entrypoint.sh"]
