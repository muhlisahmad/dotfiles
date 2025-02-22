# Arch Linux & Hyprland Installation

### This will be only as hosting for my Arch & Hyprland installation that will be pulled after Arch already installed with minimal installation.

### How to install

1. After the minimal installation of Arch finished, reboot your computer.
2. Connect to the internet
```bash
nmcli device wifi connect [your SSID] password --ask
```
3. Clone the repo and install the Hyprland installation
```bash
git clone https://github.com/muhlisahmad/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```