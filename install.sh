#!/bin/bash
# https://github.com/muhlisahmad/dotfiles

clear

# Set some colors for output messages
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
INFO="$(tput setaf 4)[INFO]$(tput sgr0)"
WARN="$(tput setaf 1)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
MAGENTA="$(tput setaf 5)"
ORANGE="$(tput setaf 214)"
WARNING="$(tput setaf 1)"
YELLOW="$(tput setaf 3)"
GREEN="$(tput setaf 2)"
BLUE="$(tput setaf 4)"
SKY_BLUE="$(tput setaf 6)"
RESET="$(tput sgr0)"

# Check if running as root. If root, script will exit
if [[ $EUID -eq 0 ]]; then
    echo "${ERROR}  This script should ${WARNING}NOT${RESET} be executed as root!! Exiting......."
    printf "\n%.0s" {1..2} 
    exit 1
fi

# Check if base-devel is installed
if pacman -Q base-devel &> /dev/null; then
    echo "base-devel is already installed."
else
    echo "$NOTE Install base-devel.........."

    if sudo pacman -S --noconfirm base-devel; then
        echo "$OK base-devel has been installed successfully."
    else
        echo "$ERROR base-devel not found nor cannot be installed."
        echo "$ACTION Please install base-devel manually before running this script... Exiting"
        exit 1
    fi
fi

clear

# install pciutils if detected not installed. Necessary for detecting GPU
if ! pacman -Qs pciutils > /dev/null; then
    echo "pciutils is not installed. Installing..."
    sudo pacman -S --noconfirm pciutils
    printf "\n%.0s" {1..1}
fi

# Function to colorize prompts
colorize_prompt() {
    local color="$1"
    local message="$2"
    echo -n "${color}${message}$(tput sgr0)"
}

# Create Directory for Install Logs
if [ ! -d Install-Logs ]; then
    mkdir Install-Logs
fi

# Define the directory where your scripts are located
script_directory=install-scripts

# Function to execute a script if it exists and make it executable
execute_script() {
    local script="$1"
    local script_path="$script_directory/$script"
    if [ -f "$script_path" ]; then
        chmod +x "$script_path"
        if [ -x "$script_path" ]; then
            "$script_path"
        else
            echo "Failed to make script '$script' executable."
        fi
    else
        echo "Script '$script' not found in '$script_directory'."
    fi
}

# Ensuring all in the scripts folder are made executable
chmod +x install-scripts/*

sleep 1

# Configuring Pacman
execute_script pacman.sh
sleep 1

# Ensuring base-devel is installed
execute_script 00-base.sh
sleep 1

# Installing yay
execute_script 01-yay.sh
sleep 1

# Installing essential packages
execute_script 02-essentials.sh
sleep 1

# Installing pipewire packages
execute_script 03-pipewire.sh
sleep 1

# Installing Intel drivers
execute_script 04-intel-driver.sh
sleep 1

# Installing Bluetooth packages
execute_script 05-bluetooth.sh
sleep 1

# Installing Location Services
execute_script 06-location.sh
sleep 1

# Installing Fonts
execute_script 07-fonts.sh
sleep 1

# Installing hypr packages
execute_script hypr-pkgs.sh