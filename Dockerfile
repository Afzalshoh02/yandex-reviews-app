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

# Зависимости Node.js и сборка Vue
RUN npm install && npm run build

# Проверка что ассеты собрались
RUN echo "=== Checking built assets ===" && \
    ls -la public/build/ && \
    echo "=== Manifest content ===" && \
    [ -f public/build/manifest.json ] && cat public/build/manifest.json || echo "No manifest file"

# Создание базы данных
RUN touch database/database.sqlite

# Копирование nginx конфига
COPY nginx.conf /etc/nginx/sites-available/default

EXPOSE 80

CMD sh -c "\
    php artisan migrate --force && \
    php artisan storage:link && \
    php artisan config:cache && \
    php artisan route:cache && \
    php artisan view:cache && \
    nginx -g 'daemon off;'"
