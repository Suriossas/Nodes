install_deamontools() {
  cd $HOME
  mkdir -p /package
  chmod 1755 /package
  cd /package

  wget http://cr.yp.to/daemontools/daemontools-0.76.tar.gz
  tar -xzvf daemontools-0.76.tar.gz
  cd admin/daemontools-0.76

  # Добавляем параметр в строку с gcc
  CONFIG_FILE="src/conf-cc"
  grep -q 'gcc' "$CONFIG_FILE"
  if [[ $? -eq 0 ]]; then
    sed -i '/gcc/s/$/ -include \/usr\/include\/errno.h/' "$CONFIG_FILE"
    echo "Добавлено -include /usr/include/errno.h в строку с gcc."
  else
    echo "Строка с gcc не найдена в файле $CONFIG_FILE."
    exit 1
  fi

  package/install
}

install_deamontools