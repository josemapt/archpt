#!/bin/bash

echo "==> Generating locales..."
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
locale-gen
echo "done"

echo "==> Creating vconsole..."
KEYMAP=es
echo "done"

echo "==> Setting hosts..."
echo "jm-arch" > /etc/hostname
echo "\n127.0.0.1	localhost\n::1		localhost\n127.0.1.1	jm-arch.localdomain	jm-arch" >> /etc/hostname
echo "done"

echo "==> Setting root password..."
passwd
echo "done"

echo "==> Creating a new user..."
useradd -m josema
passwd josema
usermod -aG wheel,audio,video,optical,storage josema
echo "done"

echo "==> Installing necesary pakages..."
pacman -S --needed --noconfirm neovim networkmanager
systemctl enable NetworkManager
echo "done"