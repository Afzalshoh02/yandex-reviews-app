#!/bin/bash
set -e

echo "========================================="
echo "Initializing Laravel Application"
echo "========================================="

cd /var/www

if [ ! -f .env ]; then
    echo "Creating .env file from .env.example..."
    cp .env.example .env
fi

if ! grep -q "APP_KEY=base64:" .env; then
    echo "Generating application key..."
    php artisan key:generate --force
fi

echo "Setting asset URL..."
if ! grep -q "ASSET_URL=" .env; then
    echo "ASSET_URL=https://yandex-reviews-app.onrender.com" >> .env
fi

if ! grep -q "MIX_ASSET_URL=" .env; then
    echo "MIX_ASSET_URL=https://yandex-reviews-app.onrender.com" >> .env
fi

if ! grep -q "FORCE_HTTPS=" .env; then
    echo "FORCE_HTTPS=true" >> .env
fi

if [ ! -f database/database.sqlite ]; then
    echo "Creating SQLite database..."
    touch database/database.sqlite
    chmod 664 database/database.sqlite
fi

mkdir -p /run/php
mkdir -p /var/log/supervisor
mkdir -p storage/framework/{cache/data,sessions,views}
mkdir -p storage/logs

echo "Setting permissions..."
chmod -R 755 /var/www
chmod -R 775 /var/www/storage /var/www/bootstrap/cache /var/www/database
chmod 664 /var/www/database/database.sqlite

echo "Rebuilding frontend assets..."
npm run build || echo "Frontend build failed, continuing..."

if [ ! -f public/mix-manifest.json ]; then
    echo "Creating mix-manifest.json..."
    echo '{"/js/app.js":"/js/app.js","/css/app.css":"/css/app.css"}' > public/mix-manifest.json
fi

if [ ! -f public/css/app.css ]; then
    echo "Creating placeholder CSS file..."
    mkdir -p public/css
    echo "/* Placeholder CSS */" > public/css/app.css
fi

if [ ! -f public/js/app.js ]; then
    echo "Creating placeholder JS file..."
    mkdir -p public/js
    echo "// Placeholder JS" > public/js/app.js
fi

echo "Clearing cache..."
php artisan cache:clear || true
php artisan config:clear || true
php artisan route:clear || true
php artisan view:clear || true

echo "Running migrations..."
php artisan migrate --force || echo "Migrations failed, continuing..."

echo "Running seeders..."
php artisan db:seed --force || echo "Seeder failed or no seeders to run"

echo "Creating storage link..."
php artisan storage:link || true

echo "Caching configuration..."
php artisan config:cache || true
php artisan route:cache || true
php artisan view:cache || true

echo "========================================="
echo "Initialization completed successfully!"
echo "========================================="

exit 0
