FROM php:8.2-fpm

# Установка системных зависимостей с четким указанием пакетов
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
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    && rm -rf /var/lib/apt/lists/*

# Установка PHP расширений по одному для лучшей отладки
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd

RUN docker-php-ext-install pdo
RUN docker-php-ext-install pdo_sqlite
RUN docker-php-ext-install mbstring
RUN docker-php-ext-install exif
RUN docker-php-ext-install pcntl
RUN docker-php-ext-install bcmath
RUN docker-php-ext-install sockets
RUN docker-php-ext-install xml
RUN docker-php-ext-install zip

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

# Установка зависимостей PHP
RUN composer install --no-dev --optimize-autoloader --no-scripts

# Установка зависимостей Node.js и сборка
RUN npm install && npm run build

EXPOSE 80

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
