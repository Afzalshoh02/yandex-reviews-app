# Yandex Reviews Dashboard  
**Отслеживание и анализ отзывов с Яндекс Карт в реальном времени**

---

## О проекте

**Yandex Reviews Dashboard** — это **современное веб-приложение на Laravel + Vue 3**, которое позволяет:

- Подключить **любой бизнес из Яндекс Карт**
- Автоматически **собирать отзывы**
- Отображать **рейтинг, звёздочки, даты, текст**
- Работать **без API Яндекса** (парсинг HTML)

---

## Особенности

| Функция | Статус |
|-------|--------|
| Синхронизация отзывов по ссылке | Done |
| Сохранение данных в БД | Done |
| Красивый дашборд с графиками | Done |
| Точные звёздочки (1.0, 4.5 и т.д.) | Done |
| Адаптивный дизайн | Done |
| Авторизация | Done |
| Sanctum + JWT | Done |

---

## Демо

> **Логин:** `admin@example.com`  
> **Пароль:** `password`


---

## Как работает

1. **Пользователь вводит ссылку на Яндекс Карты**
2. **Laravel парсит HTML** (Guzzle + DOMCrawler)
3. **Извлекает:**
   - Рейтинг из `meta[itemprop="ratingValue"]`
   - Дату из `meta[itemprop="datePublished"]`
   - Текст, автора, звёзды
4. **Сохраняет в БД (`users.reviews`)**
5. **Vue 3 отображает в реальном времени**

---

## Требования

| Технология | Версия |
|----------|--------|
| PHP | ≥ 8.1 |
| Laravel | 10.x |
| Node.js | ≥ 18 |
| MySQL / PostgreSQL | Any |
| Composer | 2.x |

---

## Установка (локально)

### 1. Клонировать репозиторий

```bash
git clone https://github.com/Afzalshoh02/yandex-reviews-app.git
cd yandex-reviews-app
```

### 2. Установить зависимости

```bash
composer install
npm install
```

### 3. Настроить `.env`

```bash
cp .env.example .env
```

Отредактируйте `.env`:

```env
APP_NAME="Yandex Reviews"
APP_URL=http://localhost:8000

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=yandex_reviews
DB_USERNAME=root
DB_PASSWORD=

```

### 4. Запустить миграции и сиды

```bash
php artisan migrate --seed
```

> Создастся админ:  
> **Email:** `admin@example.com`  
> **Пароль:** `password`

### 5. Скомпилировать фронтенд

```bash
npm run dev
```

> Или для продакшена:
```bash
npm run build
```

### 6. Запустить сервер

```bash
php artisan serve
```

Откройте: [http://localhost:8000](http://localhost:8000)

---

## Использование

1. **Войдите** как `admin@example.com`
2. Перейдите в **"Настройки"**
3. Вставьте **ссылку на Яндекс Карты**
4. Нажмите **"Сохранить ссылку"**
5. Нажмите **"Синхронизировать отзывы"**
6. Перейдите в **"Дашборд"** — отзывы загружены!

---

## Обновление

```bash
git pull
composer install --no-dev
npm install
npm run build
php artisan migrate
```

---

## Безопасность

- Sanctum + CSRF
- Валидация URL
- Ограничение частоты запросов (можно добавить `throttle`)
- HTTPS в продакшене

---

## Планы развития

| Функция | Статус |
|-------|--------|
| Telegram-уведомления о новых отзывах | Planned |
| Графики рейтинга по месяцам | Planned |
| Экспорт в Excel/PDF | Planned |
| Авто-синхронизация (Cron) | Planned |
| Мультиаккаунты (для агентств) | Planned |

---
