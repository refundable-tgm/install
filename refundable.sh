#!/bin/bash

sub_help() {
  echo "Das ist eine Hilfe"
}

sub_install() {
  if [ "$1" = "-d" ]; then
    curl -fsSL get.docker.com -o docker-install.sh
    sudo sh docker-install.sh
    rm docker-install.sh
    sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
  fi
  mkdir src/
  git clone https://github.com/refundable-tgm/huginn.git src/huginn
  git clone https://github.com/refundable-tgm/web.git src/web
  read -rp "MongoDB Admin Username: " adminusername
  read -srp "MongoDB Admin Passwort: " adminpassword
  printf "\n"
  read -rp "MongoDB Username: " username
  read -srp "MongoDB User Passwort: " userpassword
  echo "$adminusername" > config/mongodb_root_username
  echo "$adminpassword" > config/mongodb_root_password
  echo "$username" > config/mongodb_username
  echo "$userpassword" > config/mongodb_password
  printf "\nInstallation abgeschlossen."
  sub_start
}

sub_update() {
  cd src/huginn
  git pull origin master
  cd ../web
  git pull origin master
  cd ../..
  git pull origin master
  sub_stop
  sub_clean
  sub_start
  echo "Update"
}

sub_clean() {
  read -rp "Alle nicht laufenden Komponenten werden hierdurch bereinigt. Fortfahren [y|N]" y
  case $y in
    "Y" | "y" )
      docker volume rm "$(docker volume ls -f dangling=true -q)"
      docker system prune -f
      echo "Bereinigung abgeschlossen"
      ;;
    *)
      echo "Bereinigung abgebrochen."
      exit 0
      ;;
  esac
}

sub_start() {
  echo "Refundable wird nun gestartet"
  docker-compose up --build -d
  echo "Refundable wurde gestartet"
}

sub_stop() {
  echo "Refundable wird gestoppt"
  docker-compose down
  echo "Refundable wurde gestoppt"
}

sub_purge() {
  read -rp "Wollen Sie sicher Refundable deinstallieren? [y|N] " y
  case $y in
    "Y" | "y")
      sub_stop
      sub_clean
      rm -rf config images volumes docker-compose.yml README.md refundable.sh
      echo "Refundable erfolgreich deinstalliert."
      ;;
    *)
      echo "Deinstallation abgebrochen."
      exit 0
      ;;
  esac
}

sub_uninstall() {
  sub_purge
}

sub=$1
case $sub in
  "" | "-h" | "--help" | "help")
    sub_help
    ;;
  *)
    shift
    sub_"${sub}" "$@"
    if [ $? = 127 ]; then
      echo "Error: '$sub' is not a known subcommand." >&2
      sub_help
      exit 1
    fi
    ;;
esac
