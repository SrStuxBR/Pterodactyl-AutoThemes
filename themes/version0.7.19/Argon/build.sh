#!/bin/bash

set -e

########################################################
#                                                      #
#         Instalação do Pterodactyl-AutoThemes         #
#                                                      #
#           Criado e mantido por StuxDev               #
#                                                      #
#            Protegido pela licença MIT                #
#                                                      #
########################################################

#### Variáveis ####
SCRIPT_VERSION="v0.8.2"
ARGON="APP_THEME=argon"


print_brake() {
  for ((n = 0; n < $1; n++)); do
    echo -n "#"
  done
  echo ""
}


hyperlink() {
  echo -e "\e]8;;${1}\a${1}\e]8;;\a"
}


#### cores ####

GREEN="\e[0;92m"
YELLOW="\033[1;33m"
reset="\e[0m"


#### verificação do sistema operacional ####

check_distro() {
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$(echo "$ID")
    OS_VER=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then
    OS=$(lsb_release -si)
    OS_VER=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then
    . /etc/lsb-release
    OS=$(echo "$DISTRIB_ID")
    OS_VER=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then
    OS="debian"
    OS_VER=$(cat /etc/debian_version)
  elif [ -f /etc/SuSe-release ]; then
    OS="SuSE"
    OS_VER="?"
  elif [ -f /etc/redhat-release ]; then
    OS="Red Hat/CentOS"
    OS_VER="?"
  else
    OS=$(uname -s)
    OS_VER=$(uname -r)
  fi

  OS=$(echo "$OS")
  OS_VER_MAJOR=$(echo "$OS_VER" | cut -d. -f1)
}


#### Instalar dependências ####

dependencies() {
echo
print_brake 30
echo -e "* ${GREEN}Instalando dependências...${reset}"
print_brake 30
echo
case "$OS" in
debian | ubuntu)
apt-get install -y zip
;;
esac

if [ "$OS_VER_MAJOR" == "7" ]; then
sudo yum install -y zip
fi

if [ "$OS_VER_MAJOR" == "8" ]; then
sudo dnf install -y zip
fi
}


#### Backup do painel ####

backup() {
echo
print_brake 32
echo -e "* ${GREEN}Fazendo backup de segurança...${reset}"
print_brake 32
if [ -f "/var/www/pterodactyl/PanelBackup/PanelBackup.zip" ]; then
echo
print_brake 45
echo -e "* ${GREEN}Já existe um backup, pulando etapa...${reset}"
print_brake 45
echo
else
cd /var/www/pterodactyl
mkdir -p PanelBackup
zip -r PanelBackup.zip app config public resources routes storage database .env
mv PanelBackup.zip PanelBackup
fi
}


#### Donwload Files ####

download_files() {
print_brake 25
echo -e "* ${GREEN}Baixando arquivos...${reset}"
print_brake 25
cd /var/www/pterodactyl
mkdir -p temp
cd temp
curl -sSLo Argon.tar.gz https://raw.githubusercontent.com/Ferks-FK/Pterodactyl-AutoThemes/${SCRIPT_VERSION}/themes/version0.7.19/Argon/Argon.tar.gz
tar -xzvf Argon.tar.gz
cd Argon
cp -rf -- * /var/www/pterodactyl
cd
cd /var/www/pterodactyl
rm -rf temp
sed -i -e "s@APP_THEME=pterodactyl@${ARGON}@g" .env
php /var/www/pterodactyl/artisan theme:refresh-cache
php /var/www/pterodactyl/artisan view:clear
}


bye() {
print_brake 50
echo
echo -e "* ${GREEN}O tema ${YELLOW}Argon${GREEN} foi instalado com sucesso."
echo -e "* Um backup de segurança do seu painel foi criado."
echo -e "* Obrigado por usar este script."
echo
print_brake 50
}


#### Script Exec ####
check_distro
dependencies
backup
download_files
bye
