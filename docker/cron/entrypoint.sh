#!/bin/sh
set -e

mkdir -p /var/www/noon/locks

exec supercronic /etc/noon.crontab
