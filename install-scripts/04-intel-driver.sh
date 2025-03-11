#!/bin/bash
# https://github.com/muhlisahmad/dotfiles
# Intel Graphics Driver #

intel_driver=(
    mesa
    lib32-mesa
    vulkan-intel
    lib32-vulkan-intel
    # libva-mesa-driver
    # lib32-libva-mesa-driver
    # mesa-vdpau
    # lib32-mesa-vdpau
    intel-media-driver
    lib32-intel-media-driver
    libva-intel-driver
    lib32-libva-intel-driver
    libva-utils
    xorg-server
    xorg-xinit
)

## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##
source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d%m%Y-%H%M%S)_intel-driver.log"

# Intel Graphics Driver
echo -e "${NOTE} Installing ${SKY_BLUE}Intel Graphics Driver${RESET} Packages..."
for INTEL_DRIVER in "${intel_driver[@]}"; do
    install_package "$INTEL_DRIVER" "$LOG"
done

# Ensure early KMS for Intel GPU (recommended)
echo -e "${NOTE} Configuring early Kernel Mode Setting (KMS) for Intel GPU..."
if ! grep -q "^MODULES=.*i915" /etc/mkinitcpio.conf; then
    sudo sed -i 's/^MODULES=(/&i915 /' /etc/mkinitcpio.conf
    sudo mkinitcpio -P 2>&1 | tee -a "$LOG"
else
    echo -e "${OK} Early KMS already configured." 2>&1 | tee -a "$LOG"
fi

# Verify installation by checking VA-API functionality
echo -e "${NOTE} Checking VA-API support (Intel Media Driver)..."
LIBVA_DRIVER_NAME=iHD vainfo 2>&1 | tee -a "$LOG"

echo -e "\n${OK} Intel Graphics Driver Installation complete!" 2>&1 | tee -a "$LOG"

printf "\n%.0s" {1..2}