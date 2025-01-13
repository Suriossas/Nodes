#!/bin/bash

BASE_DIR="$HOME"

PATTERN="ocean_*"

for dir in "$BASE_DIR"/$PATTERN; do
    if [ -d "$dir" ]; then
        echo "Перезагружаем docker-compose в папке: $dir"
        cd "$dir" || continue
        
        echo "Выполняется docker-compose down..."
        if docker-compose down; then
            echo "docker-compose down завершён успешно."
        else
            echo "Ошибка при выполнении docker-compose down в папке: $dir" >&2
            continue
        fi

        echo "Выполняется docker-compose up -d..."
        if docker-compose up -d; then
            echo "docker-compose up завершён успешно."
        else
            echo "Ошибка при выполнении docker-compose up в папке: $dir" >&2
            continue
        fi

        echo "Завершено для папки: $dir. Переход к следующей..."
    fi
done