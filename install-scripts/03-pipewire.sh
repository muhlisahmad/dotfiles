#!/bin/bash
# https://github.com/muhlisahmad/dotfiles
# Pipewire and Pipewire Audio Stuff #

pipewire=(
    pipewire
    lib32-pipewire
    wireplumber
    pipewire-audio
    pipewire-alsa
    pipewire-jack
    pipewire-pulse
    sof-firmware
)

## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##
source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d%m%Y-%H%M%S)_pipewire.log"

# Pipewire
echo -e "${NOTE} Installing ${SKY_BLUE}Pipewire${RESET} Packages..."
for PIPEWIRE in "${pipewire[@]}"; do
    install_package "$PIPEWIRE" "$LOG"
done

echo -e "${NOTE} Activating Pipewire Services..."
# Redirect systemctl output to log file
systemctl --user enable --now pipewire.socket pipewire-pulse.socket wireplumber.service 2>&1 | tee -a "$LOG"
systemctl --user enable --now pipewire.service 2>&1 | tee -a "$LOG"

echo -e "\n${OK} Pipewire Installation and services setup complete!" 2>&1 | tee -a "$LOG"

printf "\n%.0s" {1..2}
