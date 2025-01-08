#!/bin/bash

# Порт испрользуемый воркером. По умолчанию 8080 и 5555
WORKER_PORT_1=8080
WORKER_PORT_2=5555

# Порт для скрапера. По умолчанию 8000
SCRAPER_PORT=8000

# Путь к файлу
COMPOSE_FILE_PATH="/root/.config/opl/docker-compose.yaml"
CONGIG_FILE_PATH="/root/.config/opl/config.yaml"

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --port1) WORKER_PORT_1=$2; shift ;;
        --port2) WORKER_PORT_2=$2; shift ;;
        --port3) SCRAPER_PORT=$2; shift ;;
        *) echo "Неизвестный параметр: $1"; exit 1 ;;
    esac
    shift
done

# Замена портов в файле docker-compose.yaml
sed -i \
  -e "s/8080:8080/${WORKER_PORT1}:${WORKER_PORT1}/g" \
  -e "s/5555:5555/${WORKER_PORT2}:${WORKER_PORT2}/g" \
  -e "s/8000:8000/${SCRAPER_PORT}:${SCRAPER_PORT}/g" \
  "$COMPOSE_FILE_PATH"

# Замена портов в файле docker-compose.yaml
sed -i \
  -e "s/8080/${WORKER_PORT1}:${WORKER_PORT1}/g" \
  -e "s/5555/${WORKER_PORT2}:${WORKER_PORT2}/g" \
  -e "s/8000/${SCRAPER_PORT}:${SCRAPER_PORT}/g" \
  "$CONGIG_FILE_PATH"

# Удаление контейнера
docker stop opl_worker && docker rm opl_worker
docker stop opl_scraper && docker rm opl_scraper

# Запуск ноды
cd $HOME
openledger-node --no-sandbox
