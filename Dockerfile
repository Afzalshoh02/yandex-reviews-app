FROM php:8.2-fpm

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
    supervisor \
    && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-configure gd --with-freetype --with-jpeg

RUN docker-php-ext-install \
    pdo \
    pdo_sqlite \
    mbstring \
    exif \
    pcntl \
    bcmath \
    gd \
    zip

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN useradd -ms /bin/bash appuser || true

WORKDIR /var/www

COPY . .

RUN mkdir -p /run/php \
    storage/framework/cache/data \
    storage/framework/sessions \
    storage/framework/views \
    storage/logs \
    database \
    bootstrap/cache

RUN touch database/database.sqlite

RUN chown -R root:root /var/www \
    && chmod -R 755 /var/www \
    && chmod -R 775 storage bootstrap/cache database \
    && chmod 664 database/database.sqlite

RUN composer install --no-dev --optimize-autoloader --no-interaction --prefer-dist

RUN npm ci && npm run build

RUN if [ ! -f public/mix-manifest.json ] && [ -f public/build/manifest.json ]; then \
        echo '{"/js/app.js":"/js/app.js","/css/app.css":"/css/app.css"}' > public/mix-manifest.json; \
    elif [ ! -f public/mix-manifest.json ]; then \
        echo '{"/js/app.js":"/js/app.js","/css/app.css":"/css/app.css"}' > public/mix-manifest.json; \
    fi

COPY nginx.conf /etc/nginx/sites-available/default

COPY start.sh /start.sh
RUN chmod +x /start.sh

COPY php-fpm.conf /usr/local/etc/php-fpm.d/zz-custom.conf

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
