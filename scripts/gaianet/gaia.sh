channel_logo() {
  echo -e '\033[0;31m'
  echo -e '┌┐ ┌─┐┌─┐┌─┐┌┬┐┬┬ ┬  ┌─┐┬ ┬┌┐ ┬┬  '
  echo -e '├┴┐│ ││ ┬├─┤ │ │└┬┘  └─┐└┬┘├┴┐││  '
  echo -e '└─┘└─┘└─┘┴ ┴ ┴ ┴ ┴   └─┘ ┴ └─┘┴┴─┘'
  echo -e '\e[0m'
  echo -e "\n\nПодпишись на самый 4ekHyTbIu* канал в крипте @bogatiy_sybil [💸]"
}

download_node() {
  echo 'Начинаю установку ноды...'

  cd $HOME

  sudo apt update -y && sudo apt upgrade -y
  sudo apt-get install screen nano git curl build-essential make lsof wget jq -y

  curl -fsSL https://deb.nodesource.com/setup_20.x | sudo bash -
  sudo apt-get install -y nodejs

  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
  source ~/.bashrc

  curl -o install_temp_gaia.sh https://raw.githubusercontent.com/GaiaNet-AI/gaianet-node/main/install.sh
  sed -i 's#curl -sSf https://raw.githubusercontent.com/WasmEdge/WasmEdge/master/utils/install_v2.sh | bash -s -- -v $wasmedge_version --ggmlbn=$ggml_bn --tmpdir=$tmp_dir#curl -sSf https://raw.githubusercontent.com/WasmEdge/WasmEdge/master/utils/install_v2.sh | bash -s -- -v 0.13.5 --noavx#' install_temp_gaia.sh
  sed -i 's#wasmedge_version="[^"]*"#wasmedge_version="0.13.5"#' install_temp_gaia.sh
  bash install_temp_gaia.sh
  rm install_temp_gaia.sh

  source ~/.bashrc
  source /root/.bashrc

  echo "Порт ноды: $NODE_PORT";
}

keep_download() {
  source /root/.bashrc

  gaianet init --config https://raw.gaianet.ai/qwen2-0.5b-instruct/config.json

  # Установка домена так как в последней версии gaia решила всех перевести на домены
  # gaianet config --domain us.gaianet.network
  # gaianet init

  # Установка порта
  gaianet config --port $NODE_PORT
  gaianet init  

  gaianet start

  mkdir bot
  cd bot
  git clone https://github.com/0xdmimaz/gaianet/
  cd gaianet
  npm i

  sudo wget https://raw.githubusercontent.com/Suriossas/Nodes/main/scripts/gaianet/bot_gaia.sh

  gaianet info

  cd $HOME/bot/gaianet

  read -p "Введите ваш Node ID (но перед этим зайдите по ссылке из гайда на сервере): " NEW_ID
  sed -i "s#0x0aa110d2e3a2f14fc122c849cea06d1bc9ed1c62.us.gaianet.network#$NEW_ID.gaia.domains#" config.json

  sleep 15

  screen -dmS gaianetnode bash -c '
    echo "Начало выполнения скрипта в screen-сессии"

    cd /root/bot/gaianet/
    node bot_gaia.js

    exec bash
  '

  echo "Screen сессия 'gaianetnode' создана..."
}

check_states() {
  gaianet info
}

check_logs() {
  screen -r gaianetnode
}

update_node() {
  cd $HOME

  curl -sSfL 'https://github.com/GaiaNet-AI/gaianet-node/releases/latest/download/install.sh' | bash -s -- --upgrade

  echo 'Нода обновилась...'
}

start_node() {
  gaianet start
  
  sleep 10
  
  screen -dmS gaianetnode bash -c '
    echo "Начало выполнения скрипта в screen-сессии"
    
    cd /root/bot/gaianet/
    node bot_gaia.js

    exec bash
  '

  echo "Screen сессия 'gaianetnode' создана..."
}

stop_node() {
  gaianet stop
}

delete_node() {
  cd $HOME
  curl -sSfL 'https://github.com/GaiaNet-AI/gaianet-node/releases/latest/download/uninstall.sh' | bash
  sudo rm -r bot/
  sudo rm -r gaianet/
}

exit_from_script() {
  exit 0
}

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --port) NODE_PORT=$2; shift ;;        
        *) echo "Неизвестный параметр: $1"; exit 1 ;;
    esac
    shift
done

while true; do
    channel_logo
    sleep 2
    echo -e "\n\nМеню:"
    echo "1. ✨ Установить ноду"
    echo "2. 🔰 Продолжить установку"
    echo "3. 📊 Посмотреть данные"
    echo "4. 🟦 Посмотреть логи"
    echo "5. 🔄 Обновить ноду"
    echo "6. 🚀 Запустить ноду"
    echo "7. 🛑 Остановить ноду"
    echo "8. 🗑️ Удалить ноду"
    echo -e "9. 👋 Выйти из скрипта\n"
    read -p "Выберите пункт меню: " choice

    case $choice in
      1)
        download_node
        ;;
      2)
        keep_download
        ;;
      3)
        check_states
        ;;
      4)
        check_logs
        ;;
      5)
        update_node
        ;;
      6)
        start_node
        ;;
      7)
        stop_node
        ;;
      8)
        delete_node
        ;;
      9)
        exit_from_script
        ;;
      *)
        echo "Неверный пункт. Пожалуйста, выберите правильную цифру в меню."
        ;;
    esac
  done
