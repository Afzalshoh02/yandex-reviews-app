FROM php:8.2-fpm

# Устанавливаем зависимости
RUN apt-get update && apt-get install -y \
    git zip unzip libpng-dev libonig-dev libxml2-dev libzip-dev \
    nodejs npm \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

# Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html
COPY . .

# Зависимости
RUN composer install --no-dev --optimize-autoloader
RUN npm install && npm run build

# Права на storage и bootstrap/cache
RUN chmod -R 777 storage bootstrap/cache

# CMD только для сервера (не миграции!)
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
