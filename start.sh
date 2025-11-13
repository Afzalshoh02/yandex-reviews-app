#!/bin/bash
set -e

echo "Starting application..."

# Переходим в директорию проекта
cd /var/www

# Создаем базу данных если не существует
if [ ! -f database/database.sqlite ]; then
    touch database/database.sqlite
    echo "Database created"
fi

# Запускаем миграции и сиды
php artisan migrate --force
php artisan db:seed --force
php artisan storage:link
php artisan config:cache
php artisan route:cache
php artisan view:cache

echo "Starting PHP-FPM..."
php-fpm -D

echo "Starting Nginx..."
nginx -g 'daemon off;'
