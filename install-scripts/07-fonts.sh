#!/bin/bash
# https://github.com/muhlisahmad/dotfiles
# Fonts #

fonts=(
  noto-fonts
  noto-fonts-cjk
  noto-fonts-emoji
  noot-fonts-extra
  adobe-source-code-pro-fonts
  adobe-source-sans-fonts
  adobe-source-serif-fonts
  adobe-source-han-sans-otc-fonts
  ttf-dejavu
  ttf-liberation
  ttf-hanazono
  ttf-droid 
  ttf-fira-code
  ttf-jetbrains-mono 
  ttf-jetbrains-mono-nerd 
  otf-font-awesome 
)


## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##
source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d%m%Y-%H%M%S)_fonts.log"

# Installation of main components
echo -e "${NOTE} Installing ${SKY_BLUE}fonts${RESET} ...."
for PKG1 in "${fonts[@]}"; do
  install_package "$PKG1" "$LOG"
done

printf "\n%.0s" {1..2}