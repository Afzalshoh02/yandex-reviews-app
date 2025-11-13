#!/bin/bash
set -e

echo "=== Starting Application ==="
echo "Current directory: $(pwd)"
echo "Working directory: /var/www"

# Переходим в правильную директорию
cd /var/www

echo "=== Checking database ==="
echo "Database path: /var/www/database/database.sqlite"

# Создание директории database если не существует
mkdir -p /var/www/database

# Создание базы данных если не существует
if [ ! -f /var/www/database/database.sqlite ]; then
    echo "Creating SQLite database..."
    touch /var/www/database/database.sqlite
    echo "SQLite database created at /var/www/database/database.sqlite"
else
    echo "SQLite database already exists"
fi

# Проверяем права
echo "=== Setting permissions ==="
chown -R www-data:www-data /var/www
chmod -R 755 /var/www/storage
chmod -R 755 /var/www/bootstrap/cache

echo "=== Creating storage link ==="
php artisan storage:link

echo "=== Database contents ==="
ls -la /var/www/database/

echo "=== Running migrations ==="
php artisan migrate --force

echo "=== Running seeders ==="
php artisan db:seed --force

echo "=== Caching configurations ==="
php artisan config:cache
php artisan route:cache
php artisan view:cache

echo "=== Application ready! ==="

# Запуск supervisor
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
