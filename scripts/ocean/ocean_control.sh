show_menu() {
    echo "1. Запустить скрипт по перезагрузке нод"
    echo "2. Выход"

    read -p "Выберите пункт меню: " choice

    case $choice in
        1)
            run_script
            ;;
        2)
            echo "Выход..."
            exit 0
            ;;
        *)
            echo "Неверный пункт. Пожалуйста, выберите правильную цифру в меню."
            ;;
    esac
}

run_script() {
    mkdir -p scripts/ocean
    wget -O scripts/ocean/restart_script.sh https://raw.githubusercontent.com/Suriossas/Nodes/main/scripts/ocean/restart_script.sh

    echo "Создаем cron задачу..."
    cron_job="0 */2 * * * /bin/bash $(pwd)/scripts/ocean/restart_script.sh"   

    if crontab -l | grep -Fq "$cron_job"; then
        echo "Cron задача уже существует"
    else
        (crontab -l; echo "$cron_job") | crontab -
        echo "Cron задача создана"
    fi
}

while true; do
    show_menu
done