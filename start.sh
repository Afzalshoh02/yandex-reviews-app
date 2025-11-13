#!/bin/bash
set -e

echo "========================================="
echo "Starting Laravel Application on Render"
echo "========================================="

# Переходим в директорию проекта
cd /var/www

# Проверяем наличие файла .env
if [ ! -f .env ]; then
    echo "Creating .env file from .env.example..."
    cp .env.example .env
fi

# Генерируем ключ приложения если его нет
if ! grep -q "APP_KEY=base64:" .env; then
    echo "Generating application key..."
    php artisan key:generate --force
fi

# Создаем SQLite базу данных если её нет
if [ ! -f database/database.sqlite ]; then
    echo "Creating SQLite database..."
    touch database/database.sqlite
    chmod 664 database/database.sqlite
fi

# Устанавливаем права
echo "Setting permissions..."
chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache /var/www/database
chmod -R 775 /var/www/storage /var/www/bootstrap/cache
chmod 664 /var/www/database/database.sqlite

# Очищаем кеш
echo "Clearing cache..."
php artisan cache:clear || true
php artisan config:clear || true
php artisan route:clear || true
php artisan view:clear || true

# Запускаем миграции
echo "Running migrations..."
php artisan migrate --force

# Запускаем сидеры
echo "Running seeders..."
php artisan db:seed --force || echo "Seeder failed or no seeders to run"

# Создаем симлинк для storage
echo "Creating storage link..."
php artisan storage:link || true

# Кешируем конфигурацию
echo "Caching configuration..."
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Запускаем PHP-FPM
echo "Starting PHP-FPM..."
php-fpm -D

# Проверяем, что PHP-FPM запустился
sleep 2
if ! pgrep php-fpm > /dev/null; then
    echo "ERROR: PHP-FPM failed to start"
    exit 1
fi

# Запускаем Nginx
echo "Starting Nginx..."
echo "========================================="
echo "Application started successfully!"
echo "========================================="

# Nginx в foreground режиме
exec nginx -g 'daemon off;'
