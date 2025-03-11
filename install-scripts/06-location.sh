#!/bin/bash
# https://github.com/muhlisahmad/dotfiles
# Location Services Installer for Arch Linux (Hyprland/Wayland) #

location_packages=(
  geoclue
)

## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##
source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d%m%Y-%H%M%S)_location.log"

# Location Packages
echo -e "${NOTE} Installing ${SKY_BLUE}Location Services${RESET} packages"
for LOCATION_PACKAGE in "${location_packages[@]}"; do
    install_package "$LOCATION_PACKAGE" "$LOG"
done

# Enable and start geoclue service
echo -e "${NOTE} Enabling and starting geoclue location service..."
sudo systemctl enable --now geoclue.service 2>&1 | tee -a "$LOG"

echo -e "\n${OK} Location Service Installation complete!" 2>&1 | tee -a "$LOG"

printf "\n%.0s" {1..2}