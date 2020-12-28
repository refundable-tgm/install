#!/bin/bash

check_installed() {
  if [ ! -d "src/" ]; then
    printf "Please install the application before executing other commands.\n"
    exit 1
  fi
}

# Help Command
sub_help() {
  printf "Usage:    %s <subcommand> \n" "$(basename "$0")"
  printf "\n"
  printf "  Subcommands:\n"
  printf "    install       -  installs refundable on this machine\n"
  printf "    install [-d]  -  if the '-d' flag is provided, docker will be installed\n"
  printf "    start         -  starts the application\n"
  printf "    stop          -  stops the application\n"
  printf "    restart       -  restarts the application\n"
  printf "    update        -  updates all components of refundable (incl. restart)\n"
  printf "    clean         -  cleans all dangling components\n"
  printf "    purge         -  removes refundable completely\n"
  printf "    uninstall     -  alias to purge\n"
}

# Install command
sub_install() {
  if [ "$1" = "-d" ]; then
    printf "Downloading Docker.\n"
    curl -fsSL get.docker.com -o docker-install.sh > /dev/null
    printf "Download complete. Now installing. This may take a while.\n"
    sudo sh docker-install.sh
    rm docker-install.sh
    printf "\n------\n\n"
    printf "Downloading Docker-Compose.\n"
    sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    printf "Download complete.\n"
    sudo chmod +x /usr/local/bin/docker-compose
    printf "Docker and Docker Compose installed successfully.\n"
    printf "\n------\n"
  fi
  mkdir src/
  printf "Downloading the Backend (huginn).\n"
  git clone --quiet https://github.com/refundable-tgm/huginn.git src/huginn > /dev/null
  printf "Download complete\nDownloading the Frontend (web).\n"
  git clone --quiet https://github.com/refundable-tgm/web.git src/web > /dev/null
  printf "Download complete.\n"
  printf "\n------\n\n"
  read -rp "Choose a MongoDB Admin Username: " adminusername
  read -srp "Choose a MongoDB Admin Password: " adminpassword
  printf "\n"
  read -rp "Choose a MongoDB Username: " username
  read -srp "Choose a MongoDB User Password: " userpassword
  echo "$adminusername" > config/mongodb_root_username
  echo "$adminpassword" > config/mongodb_root_password
  echo "$username" > config/mongodb_username
  echo "$userpassword" > config/mongodb_password
  printf "\nInstallation completed.\n"
}

# Start command
sub_start() {
  check_installed
  printf "Refundable is starting.\n"
  docker-compose up --build -d > /dev/null
  printf "Refundable started.\n"
}

# Stop command
sub_stop() {
  check_installed
  printf "Refundable is stopping.\n"
  docker-compose down > /dev/null
  printf "Refundable stopped.\n"
}

# Restart command
sub_restart() {
  check_installed
  sub_start
  sub_stop
}

# Clean functionality
clean() {
  printf "Cleaning started.\n"
  docker volume rm "$(docker volume ls -f dangling=true -q)" > /dev/null
  docker system prune -f > /dev/null
  printf "Cleaning completed.\n"
}

# Update command
sub_update() {
  check_installed
  printf "Backend (huginn) will be updated, if available.\n"
  cd src/huginn
  git pull --quiet origin master > /dev/null
  printf "Process completed.\n\n------\n\n"
  printf "Frontend (web) will be updated, if available.\n"
  cd ../web
  git pull --quiet origin master > /dev/null
  printf "Process completed.\n\n------\n\n"
  printf "Infrastructure will be updated, if available.\n"
  cd ../..
  git pull --quiet origin master > /dev/null
  printf "Process completed.\n\n------\n\n"
  sub_stop
  printf "\n------\n\n"
  clean
  printf "\n------\n\n"
  sub_start
  printf "Update process completed.\n"
}

# Clean subcommand
sub_clean() {
  check_installed
  read -rp "All dangling components will be removed. Continue? [y|N]" y
  printf "\n"
  case $y in
    "Y" | "y" )
      clean
      ;;
    *)
      printf "Cleaning aborted.\n"
      exit 0
      ;;
  esac
}

# Purge command
sub_purge() {
  check_installed
  read -rp "Refundable will be removed completely. Continue? [y|N] " y
  printf "\n"
  case $y in
    "Y" | "y")
      sub_stop
      sub_clean
      rm -rf config images volumes docker-compose.yml README.md refundable.sh src .git
      printf "Refundable was removed.\n"
      ;;
    *)
      printf "Aborted.\n"
      exit 0
      ;;
  esac
}

# Uninstall alias
sub_uninstall() {
  sub_purge
}

# Parse subcommand
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
