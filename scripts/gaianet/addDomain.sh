read -p "Ваш домен: " NODE_DOMAIN

cd $HOME/bot/gaianet
sed -i "s#\"url\":\"[^\"]*\"#\"url\":\"https://$NODE_DOMAIN/v1/chat/completions\"#" config.json

gaianet stop
gaianet config --domain gaia.domains
gaianet init
gaianet start

screen -ls | grep -E 'gaianetnode' | awk '{print $1}' | xargs -r -I{} screen -S {} -X quit

screen -dmS gaianetnode bash -c '
  echo "Начало выполнения скрипта в screen-сессии"

  cd /root/bot/gaianet/
  node bot_gaia.js

  exec bash
'