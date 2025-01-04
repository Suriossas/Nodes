#!/bin/bash

# Порт испрользуемый нодой. По умолчанию 8080
NODE_PORT=8090
# Имя контейнера докера (важно устанавливать разные)
NODE_NAME=gaianet-node-p-$NODE_PORT

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --port) NODE_PORT=$2; shift ;;
        --name) NODE_NAME=$2; shift ;;
        *) echo "Неизвестный параметр: $1"; exit 1 ;;
    esac
    shift
done

docker run --platform linux/amd64 -p $NODE_PORT:$NODE_PORT  --name $NODE_NAME ubuntu /bin/bash

docker exec $NODE_NAME sh -c "apt update -y && apt upgrade -y"
docker exec $NODE_NAME sh -c "apt install -y sudo wget"
docker exec $NODE_NAME sh -c "sudo wget https://raw.githubusercontent.com/Suriossas/Nodes/main/scripts/gaianet/gaia.sh && chmod +x gaia.sh && ./gaia.sh --port $NODE_PORT"