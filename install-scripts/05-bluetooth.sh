#!/bin/bash
# https://github.com/muhlisahmad/dotfiles
# Bluetooth Packages #

bluetooth=(
    bluez
    bluez-utils
    blueman
)

## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##
source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d%m%Y-%H%M%S)_bluetooth.log"

# Bluetooth
echo -e "${NOTE} Installing ${SKY_BLUE}Bluetooth${RESET} Packages..."
for BLUETOOTH in "${bluetooth[@]}"; do
    install_package "$BLUETOOTH" "$LOG"
done

# Enable and Start Bluetooth Services
echo -e "${NOTE} Activating Bluetooth Services..."
sudo systemctl enable --now bluetooth.service 2>&1 | tee -a "$LOG"

# Unblock Bluetooth (rfkill)
echo -e "${NOTE} Unblocking Bluetooth devices with rfkill..."
sudo rfkill unblock bluetooth 2>&1 | tee -a "$LOG"

echo -e "\n${OK} Bluetooth Installation complete!" 2>&1 | tee -a "$LOG"

printf "\n%.0s" {1..2}