#!/bin/bash
set -e

# Создание базы данных
touch /var/www/database/database.sqlite

# Установка прав
chown -R www-data:www-data /var/www
chmod -R 775 storage bootstrap/cache

# Запуск миграций и кэширования
php artisan migrate --force
php artisan db:seed --force
php artisan config:cache
php artisan route:cache
php artisan view:cache
php artisan storage:link

# Запуск PHP-FPM в фоне
php-fpm -D

# Запуск Nginx на переднем плане
nginx -g 'daemon off;'
