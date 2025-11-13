#!/bin/bash

# Проверка существования build директории
echo "Checking build directory..."
if [ -d "/var/www/public/build" ]; then
    echo "Build directory exists"
    ls -la /var/www/public/build/
    if [ -d "/var/www/public/build/assets" ]; then
        echo "Assets directory exists"
        ls -la /var/www/public/build/assets/
    fi
else
    echo "Build directory does not exist - rebuilding assets"
    npm run build
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
