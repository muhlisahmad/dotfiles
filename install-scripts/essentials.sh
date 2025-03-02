#!/bin/bash
# https://github.com/muhlisahmad/dotfiles
# Essential Packages #

base=( 
  git
  curl
  wget
  tree
  unzip
  p7zip
  inxi
)
## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##
source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_essentials.log"

for PKG1 in "${base[@]}"; do
  install_package_pacman "$PKG1" "$LOG"
done

printf "\n%.0s" {1..2}