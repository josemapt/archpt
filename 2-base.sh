#!/bin/bash

echo "==> Installing Base System..."

PKGS=(

    # --- drivers and utils
        'xf86-video-intel'
        'nvidea'
        'neovim'
        'unzip'
        'fish'

    # --- desktop enviroment
        'gnome-shell'
        'gnome-terminal'
        'gnome-control-center'
        'gnome-tweaks'
        'gdm'

    # --- programs
        'nautilus'
        'evince'
        'totem'
        'eog'
        'gnome-system-monitor'
        'file-roller'
        'baobab'
        'gnome-screenshot'
)

for PKG in "${PKGS[@]}"; do
    echo "INSTALLING: ${PKG}"
    pacman -S "$PKG" --noconfirm --needed
done

systemctl enable gdm