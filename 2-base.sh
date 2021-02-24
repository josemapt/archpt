
echo "==> Installing Base System..."

sudo pacman -S --noconfirm --needed neovim unzip fish man-db alsa-utils

if [[ ! $VBOX ]]
then
    sudo pacman -S --noconfirm --needed xf86-video-intel nvidia gnome-shell gnome-terminal gnome-control-center gnome-tweaks nautilus evince totem eog gnome-system-monitor file-roller baobab gnome-screenshot
fi