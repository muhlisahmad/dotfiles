#!/bin/bash
# https://github.com/muhlisahmad/dotfiles
# Hyprland Packages #

hypr_package=( 
  # Essentials
  curl
  wget
  tree
  unzip
  p7zip
  inxi

  # Hyprland
  hyprland

  # Logout Menu & Lockscreen
  hypridle
  hyprlock
  wlogout
  
  # Scratchpad
  pyprland

  # Text Editors
  nano
  vim
  neovim

  # Terminal Emulator
  kitty
  imagemagick # Required for kitty image support (kitty +kitten icat)
  tmux

  # Notification Daemon
  swaync

  # XDG Desktop Portal
  xdg-desktop-portal-hyprland
  xdg-desktop-portal-gtk
  qt6-wayland
  qt5-wayland
  qt5ct
  qt6ct
  
  # Required for screen sharing and taking screenshot
  grim
  slurp

  # Color Picker
  hyprpicker

  # Color Palettes Generator
  wallust

  # Authentication Agent
  hyprpolkitagent

  # Clipboard Manager
  cliphist
  wl-clipboard
  xdg-utils

  # Status bar
  waybar

  # Wallpaper
  swww

  # App Launcher
  rofi-wayland

  # Thunar File Manager
  thunar
  thunar-volman
  thunar-archive-plugin
  xarchiver
  tumbler
  ffmpegthumbnailer
  xdg-user-dirs
  gvfs
  gvfs-mtp
  gvfs-gphoto2
  udisks2
)

# Determine the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || exit 1

source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"

# Set the name of the log file to include the current date and time
INSTALL_PKGS_LOG="Install-Logs/install-$(date +%d%m%Y-%H%M%S)_hypr-pkgs.log"

# conflicting packages removal
overall_failed=0

# Installation of main components
printf "\n%s - Installing ${SKY_BLUE}necessary packages${RESET} .... \n" "${NOTE}"

for PKG1 in "${hypr_package[@]}"; do
  install_package "$PKG1" "$INSTALL_PKGS_LOG"
done

printf "\n%.0s" {1..2}

# Set Thunar as the default file manager

# Set the name of the log file to include the current date and time for setting Thunar as the default file manager
THUNAR_DEFAULT_LOG="Install-Logs/install-$(date +%d%m%Y-%H%M%S)_thunar-default.log"

printf "\n%s - Setting ${SKY_BLUE}Thunar${RESET} as the default file manager .... \n" "${NOTE}"

xdg-mime default thunar.desktop inode/directory application/x-wayland-gnome-saved-search
echo "${OK} ${MAGENTA}Thunar${RESET} is now set as the default file manager." | tee -a "$THUNAR_DEFAULT_LOG"

printf "\n%.0s" {1..2}