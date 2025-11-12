#!/bin/bash

# Создаем SQLite базу если не существует
touch database/database.sqlite

# Запускаем миграции
php artisan migrate --force

# Запускаем сидеры
php artisan db:seed --force

# Кэшируем конфигурацию
php artisan config:cache
php artisan route:cache
php artisan view:cache
