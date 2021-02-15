#!/bin/bash

# this script is prepared to be runed after chroot

echo "==> Setting zoneinfo..."
ln -sf /usr/share/zoneinfo/Europe/Madrid /etc/localtime
hwclock --systohc

echo "==> Generating locales..."
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
locale-gen

echo "==> Creating vconsole..."
echo "KEYMAP=es" > /etc/vconsole.conf

echo "==> Configuring network..."
echo "jm-arch" > /etc/hostname
echo -e "\n127.0.0.1	localhost\n::1		localhost\n127.0.1.1	jm-arch.localdomain	jm-arch" >> /etc/hosts

pacman -S networkmanager
systemctl enable NetworkManager

echo "==> Configuring users..."
passwd

useradd -m josema
passwd josema
usermod -aG wheel,audio,video,optical,storage josema

sed -i 's/^# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers