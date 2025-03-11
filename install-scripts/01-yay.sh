#!/bin/bash
# https://github.com/muhlisahmad/dotfiles
# Yay AUR Helper #
# NOTE: If paru is already installed, yay will not be installed #

pkg="yay-bin"

## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##
source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d%m%Y-%H%M%S)_yay.log"

# Check for AUR helper and install if not found
ISAUR=$(command -v yay || command -v paru)
if [ -n "$ISAUR" ]; then
  printf "\n%s - ${SKY_BLUE}AUR helper${RESET} already installed, moving on.\n" "${OK}"
else
  printf "\n%s - Installing ${SKY_BLUE}$pkg${RESET} from AUR\n" "${NOTE}"

# Check if folder exists and remove it
if [ -d "$pkg" ]; then
    rm -rf "$pkg"
fi
  git clone https://aur.archlinux.org/$pkg.git || { printf "%s - Failed to clone ${YELLOW}$pkg${RESET} from AUR\n" "${ERROR}"; exit 1; }
  cd $pkg || { printf "%s - Failed to enter $pkg directory\n" "${ERROR}"; exit 1; }
  makepkg -si --noconfirm 2>&1 | tee -a "../$LOG" || { printf "%s - Failed to install ${YELLOW}$pkg${RESET} from AUR\n" "${ERROR}"; exit 1; }
  cd ..
fi

# Update system before proceeding
printf "\n%s - Performing a full system update to avoid issues.... \n" "${NOTE}"
ISAUR=$(command -v yay || command -v paru)

$ISAUR -Syu --noconfirm 2>&1 | tee -a "$LOG" || { printf "%s - Failed to update system\n" "${ERROR}"; exit 1; }

printf "\n%.0s" {1..2}