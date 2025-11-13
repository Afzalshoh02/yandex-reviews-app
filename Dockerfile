FROM php:8.2-fpm

# Установка системных зависимостей
RUN apt-get update && apt-get install -y \
    nginx \
    sqlite3 \
    libsqlite3-dev \
    nodejs \
    npm \
    curl \
    git \
    unzip \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    zip \
    && rm -rf /var/lib/apt/lists/*

# Конфигурация GD
RUN docker-php-ext-configure gd --with-freetype --with-jpeg

# Установка PHP расширений
RUN docker-php-ext-install \
    pdo \
    pdo_sqlite \
    mbstring \
    exif \
    pcntl \
    bcmath \
    gd \
    zip

# Установка Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Рабочая директория
WORKDIR /var/www

# Копирование файлов проекта
COPY . .

# Создание необходимых директорий
RUN mkdir -p storage/framework/cache/data \
    storage/framework/sessions \
    storage/framework/views \
    storage/logs \
    database \
    bootstrap/cache

# Создание SQLite базы данных
RUN touch database/database.sqlite

# Установка прав доступа
RUN chown -R www-data:www-data /var/www \
    && chmod -R 775 storage bootstrap/cache database

# Установка зависимостей PHP
RUN composer install --no-dev --optimize-autoloader --no-interaction --prefer-dist

# Установка зависимостей Node.js и сборка фронтенда
RUN npm install && npm run build

# Копирование конфигурации Nginx
COPY nginx.conf /etc/nginx/sites-available/default

# Копирование стартового скрипта
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Открываем порт
EXPOSE 80

# Запуск приложения
CMD ["/start.sh"]
