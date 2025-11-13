FROM php:8.2-fpm

# Установка зависимостей
RUN apt-get update && apt-get install -y \
    nginx \
    supervisor \
    sqlite3 \
    nodejs \
    npm \
    curl \
    git \
    unzip \
    libpng-dev \
    libonig-dev \
    libxml2-dev

# Установка PHP расширений
RUN docker-php-ext-install pdo pdo_sqlite mbstring exif pcntl bcmath gd

# Установка Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Создание структуры директорий
RUN mkdir -p /var/log/nginx /var/log/supervisor

# Рабочая директория
WORKDIR /var/www

# Копирование файлов приложения
COPY . .

# Копирование конфигураций
COPY nginx.conf /etc/nginx/sites-available/default
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Установка прав
RUN chown -R www-data:www-data /var/www \
    && chmod -R 775 /var/www/storage \
    && chmod -R 775 /var/www/bootstrap/cache

# Установка зависимостей
RUN composer install --no-dev --optimize-autoloader --no-scripts
RUN npm install && npm run build

# Создание базы данных
RUN touch /var/www/database/database.sqlite

EXPOSE 80

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
