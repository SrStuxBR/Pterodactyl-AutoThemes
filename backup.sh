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

#### Variáveis ​​Fixas ####

SUPPORT_LINK="https://discord.gg/Gjya95e"

#### Update Variables ####

update_variables() {
INFORMATIONS="/var/log/Pterodactyl-AutoThemes-informations"
DET="$PTERO/public/themes/pterodactyl/css/admin.css"
ZING="$PTERO/resources/scripts/components/SidePanel.tsx"
if [ -f "${INFORMATIONS}/background.txt" ]; then BACKGROUND="$(cat "${INFORMATIONS}/background.txt")"; fi
}

print_brake() {
  for ((n = 0; n < $1; n++)); do
    echo -n "#"
  done
  echo ""
}

print() {
  echo ""
  echo -e "* ${GREEN}$1${RESET}"
  echo ""
}

print_warning() {
  echo ""
  echo -e "* ${YELLOW}AVISO${RESET}: $1"
  echo ""
}

print_error() {
  echo ""
  echo -e "* ${RED}ERRO${RESET}: $1"
  echo ""
}

hyperlink() {
  echo -e "\e]8;;${1}\a${1}\e]8;;\a"
}

GREEN="\e[0;92m"
YELLOW="\033[1;33m"
RESET="\e[0m"
RED='\033[0;31m'

#### Descubra onde o pterodactyl está instalado ####

find_pterodactyl() {
print "Procurando sua instalação de pterodactyl..."

sleep 2
if [ -d "/var/www/pterodactyl" ]; then
    PTERO_INSTALL=true
    PTERO="/var/www/pterodactyl"
  elif [ -d "/var/www/panel" ]; then
    PTERO_INSTALL=true
    PTERO="/var/www/panel"
  elif [ -d "/var/www/ptero" ]; then
    PTERO_INSTALL=true
    PTERO="/var/www/ptero"
  else
    PTERO_INSTALL=false
fi
# Atualize as variáveis ​​após a detecção da instalação do pterodactyl #
update_variables
}

#### Exclui todos os arquivos instalados pelo script ####

delete_files() {
#### TEMAS DRÁCULA, ENOLA E CREPÚSCULO ####
if [ -f "$DET" ]; then
  rm -rf "$DET"
  rm -rf "$PTERO/resources/scripts/user.css"
fi
#### TEMAS DRÁCULA, ENOLA E CREPÚSCULO ####

#### TEMA ZINGTHEME ####
if [ -f "$ZING" ]; then
  rm -rf "$ZING"
  rm -rf "$PTERO/resources/scripts/components/server/files/FileViewer.tsx"
fi
#### TEMA ZINGTHEME ####

#### VÍDEO DE FUNDO ####
if [ -f "$PTERO/public/$BACKGROUND" ]; then
  rm -rf "$PTERO/public/$BACKGROUND"
  rm -rf "$PTERO/resources/scripts/user.css"
  rm -rf "$INFORMATIONS"
fi
#### VÍDEO DE FUNDO ####
}

#### Restaurar backup ####

restore() {
print "Verificando um backup..."

if [ -d "$PTERO/PanelBackup[Auto-Themes]" ]; then
    cd "$PTERO/PanelBackup[Auto-Themes]"
    tar -xzvf "$PTERO/PanelBackup[Auto-Themes]/PanelBackup[Auto-Themes].tar.gz"
    rm -rf "$PTERO/PanelBackup[Auto-Themes]/PanelBackup[Auto-Themes].tar.gz"
    cp -r -- * .env "$PTERO"
    rm -rf "$PTERO/PanelBackup[Auto-Themes]"
  else
    print_error "Não havia backup para restaurar, Abortando..."
    exit 1
fi
}

bye() {
print_brake 50
echo
echo -e "${GREEN}* Backup restaurado com sucesso!"
echo -e "* Obrigado por usar este script."
echo -e "* Grupo de suporte: ${YELLOW}$(hyperlink "$SUPPORT_LINK")${RESET}"
echo
print_brake 50
}

#### Exec Script ####
find_pterodactyl
if [ "$PTERO_INSTALL" == true ]; then
    print "Instalação do painel encontrada, continuando o backup..."
    delete_files
    restore
    bye
  elif [ "$PTERO_INSTALL" == false ]; then
    print_warning "Não foi possível localizar a instalação do seu painel."
    echo -e "* ${GREEN}EXAMPLE${RESET}: ${YELLOW}/var/www/mypanel${RESET}"
    echo -ne "* Insira o diretório de instalação do pterodáctilo manualmente: "
    read -r MANUAL_DIR
    if [ -d "$MANUAL_DIR" ]; then
        print "O diretório foi encontrado!"
        PTERO="$MANUAL_DIR"
        echo "$MANUAL_DIR" >> "$INFORMATIONS/custom_directory.txt"
        update_variables
        delete_files
        restore
        bye
      else
        print_error "O diretório que você digitou não existe."
        find_pterodactyl
    fi
fi
