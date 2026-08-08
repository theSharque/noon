FROM php:5.6-fpm

RUN sed -i 's/deb.debian.org/archive.debian.org/g' /etc/apt/sources.list \
 && sed -i 's|security.debian.org|archive.debian.org|g' /etc/apt/sources.list \
 && sed -i '/stretch-updates/d' /etc/apt/sources.list \
 && apt-get -o Acquire::Check-Valid-Until=false update \
 && apt-get install -y --allow-unauthenticated --no-install-recommends \
    libpng-dev \
    libjpeg62-turbo-dev \
 && docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
 && docker-php-ext-install mysql mbstring shmop gd \
 && rm -rf /var/lib/apt/lists/* \
 && echo "date.timezone=Europe/Moscow" > /usr/local/etc/php/conf.d/timezone.ini \
 && echo "default_charset = UTF-8" > /usr/local/etc/php/conf.d/charset.ini

WORKDIR /var/www/noon
RUN mkdir -p /var/www/noon/locks \
 && chown -R www-data:www-data /var/www/noon
