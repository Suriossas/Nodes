#!/bin/bash

PID_FILE="/gaianet/llamaedge.pid"
PROCESS_CMD="gaianet start"

while true; do
  if [[ -f $PID_FILE ]]; then
    PID=$(cat "$PID_FILE")

    if ! ps -p "$PID" > /dev/null 2>&1; then
      echo "$(date): Процесс с PID $PID не найден. Перезапускаю..."
      $PROCESS_CMD
    fi
  else
    echo "$(date): PID-файл не найден. Перезапускаю процесс..."
    $PROCESS_CMD
  fi

  sleep 10
done