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

# Obtenha a versão mais recente antes de executar o script #
get_release() {
curl --silent \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/SrStuxBR/Pterodactyl-AutoThemes/releases/latest |
  grep '"tag_name":' |
  sed -E 's/.*"([^"]+)".*/\1/'
}

GITHUB_STATUS_URL="https://www.githubstatus.com"
SCRIPT_VERSION="$(get_release)"

# funções visuais #
print_brake() {
  for ((n = 0; n < $1; n++)); do
    echo -n "#"
  done
  echo ""
}

hyperlink() {
  echo -e "\e]8;;${1}\a${1}\e]8;;\a"
}

YELLOW="\033[1;33m"
RESET="\e[0m"
RED='\033[0;31m'

error() {
  echo ""
  echo -e "* ${RED}ERROR${RESET}: $1"
  echo ""
}

# Verificar Sudo #
if [[ $EUID -ne 0 ]]; then
  echo "* Este script deve ser executado com privilégios de root (sudo)." 1>&2
  exit 1
fi

# Verifique o Git #
if [ -z "$SCRIPT_VERSION" ]; then
  error "Não foi possível obter a versão do script usando o GitHub."
  echo "* Verifique no site abaixo se as 'solicitações de API' estão com o status normal."
  echo -e "${YELLOW}$(hyperlink "$GITHUB_STATUS_URL")${RESET}"
  exit 1
fi

# Verificar Curl #
if ! [ -x "$(command -v curl)" ]; then
  echo "* curl é necessário para que este script funcione."
  echo "* instale usando apt (Debian e derivados) ou yum/dnf (CentOS)"
  exit 1
fi

cancel() {
echo
echo -e "* ${RED}Instalação cancelada!${RESET}"
done=true
exit 1
}

done=false

echo
print_brake 70
echo "* Pterodactyl-AutoThemes Script @ $SCRIPT_VERSION"
echo
echo "* Copyright (C) 2022 - $(date +%Y), SrStuxBR."
echo "* https://github.com/SrStuxBR/Pterodactyl-AutoThemes"
echo
echo "* Este script não está associado ao Projeto Pterodactyl oficial."
print_brake 70
echo

Backup() {
bash <(curl -s https://raw.githubusercontent.com/SrStuxBR/Pterodactyl-AutoThemes/"${SCRIPT_VERSION}"/backup.sh)
}

Dracula() {
bash <(curl -s https://raw.githubusercontent.com/SrStuxBR/Pterodactyl-AutoThemes/"${SCRIPT_VERSION}"/themes/version1.x/Dracula/build.sh)
}

Enola() {
bash <(curl -s https://raw.githubusercontent.com/SrStuxBR/Pterodactyl-AutoThemes/"${SCRIPT_VERSION}"/themes/version1.x/Enola/build.sh)
}

Twilight() {
bash <(curl -s https://raw.githubusercontent.com/SrStuxBR/Pterodactyl-AutoThemes/"${SCRIPT_VERSION}"/themes/version1.x/Twilight/build.sh)
}

ZingTheme() {
bash <(curl -s https://raw.githubusercontent.com/SrStuxBR/Pterodactyl-AutoThemes/"${SCRIPT_VERSION}"/themes/version1.x/ZingTheme/build.sh)
}

FlancoTheme() {
bash <(curl -s https://raw.githubusercontent.com/SrStuxBR/Pterodactyl-AutoThemes/"${SCRIPT_VERSION}"/themes/version1.x/FlancoTheme/build.sh)
}

BackgroundVideo() {
bash <(curl -s https://raw.githubusercontent.com/SrStuxBR/Pterodactyl-AutoThemes/"${SCRIPT_VERSION}"/themes/version1.x/BackgroundVideo/build.sh)
}

AnimatedGraphics() {
bash <(curl -s https://raw.githubusercontent.com/SrStuxBR/Pterodactyl-AutoThemes/"${SCRIPT_VERSION}"/themes/version1.x/AnimatedGraphics/build.sh)
}


while [ "$done" == false ]; do
  options=(
    "Restaurar backup do painel (somente se você tiver um problema de instalação.)"
    "Instale o Drácula (somente 1.6.6 e 1.7.0)"
    "Instale o Enola (somente 1.6.6 e 1.7.0)"
    "Instale o Twilight (somente 1.6.6 e 1.7.0)"
    "Instale o tema Zing (somente 1.6.6 e 1.7.0)"
    "Instale o Flanco Theme (somente 1.6.6 e 1.7.0)"
    "Instale o vídeo de fundo (somente 1.6.6 e 1.7.0)"
    "Instalar gráficos animados (somente 1.6.6 e 1.7.0)"
    
    
    "Cancelar instalação"
  )
  
  actions=(
    "Backup"
    "Dracula"
    "Enola"
    "Twilight"
    "ZingTheme"
    "FlancoTheme"
    "BackgroundVideo"
    "AnimatedGraphics"
    
    
    "cancel"
  )
  
  echo "* Qual tema você deseja instalar?"
  echo
  
  for i in "${!options[@]}"; do
    echo "[$i] ${options[$i]}"
  done
  
  echo
  echo -n "* Entrada 0-$((${#actions[@]} - 1)): "
  read -r action
  
  [ -z "$action" ] && error "A entrada é necessária" && continue
  
  valid_input=("$(for ((i = 0; i <= ${#actions[@]} - 1; i += 1)); do echo "${i}"; done)")
  [[ ! " ${valid_input[*]} " =~ ${action} ]] && error "Opção inválida"
  [[ " ${valid_input[*]} " =~ ${action} ]] && done=true && eval "${actions[$action]}"
done
