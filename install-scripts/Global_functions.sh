#!/bin/bash
# https://github.com/muhlisahmad/dotfiles

set -e

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

# Create Directory for Install Logs
if [ ! -d Install-Logs ]; then
    mkdir Install-Logs
fi

ISAUR=$(command -v yay || command -v paru)

# Function to install packages with pacman
install_package_pacman() {
  local pkg="$1"
  local LOG="$2"
  local attempts=0
  local max_attempts=3

  # Check if package is already installed
  if pacman -Q "$pkg" &>/dev/null ; then
    echo -e "${INFO} ${MAGENTA}$pkg${RESET} is already installed. Skipping..."
    return
  fi

  echo -e "${NOTE} Installing ${SKY_BLUE}$pkg${RESET}..."

  (
    stdbuf -oL sudo pacman -S --noconfirm "$pkg" 2>&1
  ) >> "$LOG" 2>&1

  if pacman -Q "$pkg" &>/dev/null ; then
    echo -e "${OK} Package ${YELLOW}$pkg${RESET} has been successfully installed!"
  else
    echo -e "${WARN} Initial installation of ${YELLOW}$pkg${RESET} failed. Retrying up to 2 more times..."
    attempts=1
    max_attempts=3
    while [ $attempts -lt $max_attempts ] && ! pacman -Q "$pkg" &>/dev/null; do
      attempts=$((attempts + 1))
      echo -e "${WARN} Retrying ${YELLOW}$pkg${RESET} (Attempt ${attempts}/${max_attempts})..."

      (
        stdbuf -oL sudo pacman -S --noconfirm "$pkg" 2>&1
      ) >> "$LOG" 2>&1

      if pacman -Q "$pkg" &>/dev/null; then
        echo -e "${OK} Package ${YELLOW}$pkg${RESET} successfully installed on retry ${attempts}!"
        return
      else
        echo -e "${WARN} ${YELLOW}$pkg${RESET} retry attempt ${attempts} failed."
        sleep 2
      fi
    done

    if ! pacman -Q "$pkg" &>/dev/null; then
      echo -e "${ERROR} ${YELLOW}$pkg${RESET} failed to install after ${max_attempts} attempts. Please check the ${LOG}. You may need to install manually."
    fi
  fi
}

# Function to install packages with either yay or paru
install_package() {
  local pkg="$1"
  local LOG="$2"
  local attempts=0
  local max_attempts=3

  if $ISAUR -Q "$pkg" &>> /dev/null ; then
    echo -e "${INFO} ${MAGENTA}$pkg${RESET} is already installed. Skipping..."
    return
  fi

  echo -e "${NOTE} Installing ${SKY_BLUE}$pkg${RESET}..."

  (
    stdbuf -oL $ISAUR -S --noconfirm "$pkg" 2>&1
  ) >> "$LOG" 2>&1

  if $ISAUR -Q "$pkg" &>> /dev/null ; then
    echo -e "${OK} Package ${YELLOW}$pkg${RESET} has been successfully installed!"
  else
    echo -e "${WARN} Initial installation of ${YELLOW}$pkg${RESET} failed. Retrying up to 2 more times..."
    attempts=1
    max_attempts=3
    while [ $attempts -lt $max_attempts ] && ! $ISAUR -Q "$pkg" &>> /dev/null; do
      attempts=$((attempts + 1))
      echo -e "${WARN} Retrying ${YELLOW}$pkg${RESET} (Attempt ${attempts}/${max_attempts})..."

      (
        stdbuf -oL $ISAUR -S --noconfirm "$pkg" 2>&1
      ) >> "$LOG" 2>&1

      if $ISAUR -Q "$pkg" &>> /dev/null; then
        echo -e "${OK} Package ${YELLOW}$pkg${RESET} successfully installed on retry ${attempts}!"
        return
      else
        echo -e "${WARN} ${YELLOW}$pkg${RESET} retry attempt ${attempts} failed."
        sleep 2
      fi
    done

    if ! $ISAUR -Q "$pkg" &>> /dev/null; then
      echo -e "${ERROR} ${YELLOW}$pkg${RESET} failed to install after ${max_attempts} attempts. Please check the ${LOG}. You may need to install manually."
    fi
  fi
}

# Function for removing packages
uninstall_package() {
  local pkg="$1"

  # Checking if package is installed
  if pacman -Qi "$pkg" &>/dev/null; then
    echo -e "${NOTE} removing $pkg ..."
    sudo pacman -R --noconfirm "$pkg" 2>&1 | tee -a "$LOG" | grep -v "error: target not found"
    
    if ! pacman -Qi "$pkg" &>/dev/null; then
      echo -e "\e[1A\e[K${OK} $pkg removed."
    else
      echo -e "\e[1A\e[K${ERROR} $pkg Removal failed. No actions required."
      return 1
    fi
  else
    echo -e "${INFO} Package $pkg not installed, skipping."
  fi
  return 0
}