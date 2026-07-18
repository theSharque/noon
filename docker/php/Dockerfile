FROM php:5.6-fpm

RUN docker-php-ext-install mysql mbstring shmop \
 && echo "default_charset = UTF-8" > /usr/local/etc/php/conf.d/charset.ini

WORKDIR /var/www/noon

COPY www_new/ /var/www/noon/
RUN mkdir -p /var/www/noon/locks \
 && chown -R www-data:www-data /var/www/noon
