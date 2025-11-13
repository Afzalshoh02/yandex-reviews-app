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

# Создание лог директорий
RUN mkdir -p /var/log/nginx /var/log/supervisor

# Установка прав
RUN chown -R www-data:www-data /var/www \
    && chmod -R 755 /var/www/storage \
    && chmod -R 755 /var/www/bootstrap/cache

# Установка зависимостей PHP
RUN composer install --no-dev --optimize-autoloader

# Установка зависимостей Node.js и сборка Vue
RUN npm install && npm run build

# Кэширование конфигурации
RUN php artisan config:cache \
    && php artisan route:cache \
    && php artisan view:cache

EXPOSE 80

# Создание скрипта запуска
RUN echo '#!/bin/bash\n\
set -e\n\
\n\
echo "Starting application..."\n\
\n\
# Переходим в рабочую директорию\n\
cd /var/www\n\
\n\
# Создание базы данных если не существует\n\
if [ ! -f /var/www/database/database.sqlite ]; then\n\
    touch /var/www/database/database.sqlite\n\
    echo "SQLite database created at /var/www/database/database.sqlite"\n\
fi\n\
\n\
# Установка правильных прав\n\
chown -R www-data:www-data /var/www\n\
chmod -R 755 /var/www/storage\n\
chmod -R 755 /var/www/bootstrap/cache\n\
\n\
# Создание симлинка для storage\n\
php artisan storage:link\n\
\n\
# Применение миграций\n\
echo "Running migrations..."\n\
php artisan migrate --force\n\
\n\
# Запуск сидов\n\
echo "Running seeders..."\n\
php artisan db:seed --force\n\
\n\
# Пересоздание кэша после миграций\n\
php artisan config:cache\n\
php artisan route:cache\n\
php artisan view:cache\n\
\n\
echo "Application is ready!"\n\
\n\
# Запуск supervisor\n\
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf\n\
' > /usr/local/bin/start.sh && chmod +x /usr/local/bin/start.sh

# Копируем скрипт запуска
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

CMD ["/usr/local/bin/start.sh"]

