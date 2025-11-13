FROM php:8.2-fpm

# Установка системных пакетов
RUN apt-get update && apt-get install -y \
    nginx \
    sqlite3 \
    nodejs \
    npm \
    curl \
    git \
    unzip \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    && rm -rf /var/lib/apt/lists/*

# PHP расширения
RUN docker-php-ext-install pdo pdo_sqlite mbstring

# Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Рабочая директория
WORKDIR /var/www
COPY . .

# Копирование nginx конфига
COPY nginx-fpm.conf /etc/nginx/sites-available/default

# Установка прав
RUN chown -R www-data:www-data /var/www
RUN chmod -R 775 storage bootstrap/cache

# Зависимости
RUN composer install --no-dev --optimize-autoloader --no-scripts
RUN npm install && npm run build

# Создание базы данных
RUN touch database/database.sqlite

EXPOSE 80

# Запуск через скрипт
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
