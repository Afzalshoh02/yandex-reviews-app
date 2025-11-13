#!/bin/bash

echo "Starting application..."

# Создание базы данных если не существует
if [ ! -f /var/www/database/database.sqlite ]; then
    touch /var/www/database/database.sqlite
    echo "SQLite database created"
fi

# Установка правильных прав
chown -R www-data:www-data /var/www
chmod -R 755 /var/www/storage
chmod -R 755 /var/www/bootstrap/cache

# Создание симлинка для storage
php artisan storage:link

# Применение миграций
echo "Running migrations..."
php artisan migrate --force

# Запуск сидов
echo "Running seeders..."
php artisan db:seed --force

# Очистка и пересоздание кэша
echo "Caching configurations..."
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Запуск supervisor
echo "Starting supervisor..."
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
