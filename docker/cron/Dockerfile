FROM php:5.6-cli

ARG SUPERCRONIC_VERSION=0.2.29

RUN docker-php-ext-install mysql mbstring shmop \
 && echo "date.timezone=Europe/Moscow" > /usr/local/etc/php/conf.d/timezone.ini \
 && curl -fsSL "https://github.com/aptible/supercronic/releases/download/v${SUPERCRONIC_VERSION}/supercronic-linux-amd64" \
      -o /usr/local/bin/supercronic \
 && chmod +x /usr/local/bin/supercronic

WORKDIR /var/www/noon

COPY docker/cron/crontab /etc/noon.crontab
COPY docker/cron/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
