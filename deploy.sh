#!/bin/bash

echo "Starting deployment..."

# Остановка всех контейнеров
docker-compose down

# Сборка образов
docker-compose build --no-cache

# Запуск контейнеров
docker-compose up -d

echo "Deployment completed!"
