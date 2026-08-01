FROM node:20-alpine AS frontend
WORKDIR /build
COPY frontend/package.json frontend/package-lock.json* ./
RUN npm install
COPY frontend/ ./
RUN npm run build

FROM php:5.6-fpm

RUN docker-php-ext-install mysql mbstring shmop \
 && echo "default_charset = UTF-8" > /usr/local/etc/php/conf.d/charset.ini

WORKDIR /var/www/noon

COPY www/ /var/www/noon/
RUN rm -rf /var/www/noon/app /var/www/noon/admin
COPY --from=frontend /build/dist /var/www/noon/app/
COPY --from=frontend /build/dist-admin /var/www/noon/admin/
RUN mkdir -p /var/www/noon/locks \
 && chown -R www-data:www-data /var/www/noon
