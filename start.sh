#!/bin/bash
set -e

echo "========================================="
echo "Initializing Laravel Application"
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

# Создаем необходимые директории
mkdir -p /run/php
mkdir -p /var/log/supervisor
mkdir -p storage/framework/{cache/data,sessions,views}
mkdir -p storage/logs

# Устанавливаем права
echo "Setting permissions..."
chmod -R 755 /var/www
chmod -R 775 /var/www/storage /var/www/bootstrap/cache /var/www/database
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

echo "========================================="
echo "Initialization completed successfully!"
echo "========================================="

# Завершаем скрипт инициализации
exit 0
