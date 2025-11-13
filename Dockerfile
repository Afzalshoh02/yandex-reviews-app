FROM php:8.2-cli

# Установка системных пакетов
RUN apt-get update && apt-get install -y \
    nginx \
    sqlite3 \
    nodejs \
    npm \
    curl \
    git \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Рабочая директория
WORKDIR /var/www
COPY . .

# Установка прав
RUN chmod -R 775 storage bootstrap/cache

# Зависимости PHP
RUN composer install --no-dev --optimize-autoloader --no-scripts

# Зависимости Node.js и сборка
RUN npm install && npm run build

# Создание базы данных
RUN touch database/database.sqlite

EXPOSE 8000

CMD sh -c "\
    php artisan migrate --force && \
    php artisan storage:link && \
    php artisan config:cache && \
    php artisan route:cache && \
    php -S 0.0.0.0:8000 -t public"
