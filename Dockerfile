FROM php:8.2-fpm

# Установка зависимостей
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    sqlite3 \
    libsqlite3-dev \
    nginx \
    nodejs \
    npm \
    supervisor

# Очистка кеша
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Установка PHP расширений
RUN docker-php-ext-install pdo_sqlite mbstring exif pcntl bcmath gd sockets

# Установка Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Создание директории приложения
WORKDIR /var/www

# Копирование файлов приложения
COPY . /var/www

# Копирование конфигурационных файлов
COPY nginx.conf /etc/nginx/sites-available/default
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Установка прав
RUN chown -R www-data:www-data /var/www \
    && chmod -R 755 /var/www/storage \
    && chmod -R 755 /var/www/bootstrap/cache

# Установка зависимостей PHP
RUN composer install --no-dev --optimize-autoloader

# Установка зависимостей Node.js и сборка Vue
RUN npm install && npm run build

# Создание базы данных SQLite
RUN touch /var/www/database/database.sqlite

# Кэширование конфигурации (без миграций и сидов)
RUN php artisan config:cache \
    && php artisan route:cache \
    && php artisan view:cache

EXPOSE 80

# Скрипт запуска, который выполнит миграции при старте контейнера
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

CMD ["/usr/local/bin/start.sh"]
