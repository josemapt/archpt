#!/bin/bash

echo "==> Checking network connection..."
if ping -c 1 google.com >/dev/null
then
    echo "done"
else
    echo "Network not found"
    echo "Please connect to Internet before running this script"
    exit -1
fi

echo "==> Refreshing mirrorlist (spain)..."
curl -s -o mirrorlist_spain https://archlinux.org/mirrorlist/?country=ES&protocol=http&protocol=https&ip_version=4
curl -s -o mirrorlist_germany https://archlinux.org/mirrorlist/?country=DE&protocol=http&protocol=https&ip_version=4
curl -s -o mirrorlist_france https://archlinux.org/mirrorlist/?country=FR&protocol=http&protocol=https&ip_version=4

cat mirrorlist_spain mirrorlist_france mirrorlist_germany > /etc/pacman.d/mirrorlist
sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist

# disk (mbr) ------------------------------------------------------------------------
echo "==> Preparing disk for insmtallation (mbr)..."

echo -n "Enter disk name (/dev/sda, /dev/nvme0n1 ...): "
read DISK

echo "formating ${DISK}1 as linux swap"
mkswap "${DISK}1"
swapon "${DISK}1"

echo "formating ${DISK}2 as ext4"
mkfs.ext4 "${DISK}2"

echo "mounting ${DISK}2 at /mnt"
mount "${DISK}2" /mnt


# Arch Linux installation -------------------------------------------------------------
echo "==> Installing linux..."
pacstrap /mnt base base-devel linux linux-firmware intel-ucode

echo "generating fstab"
genfstab -U /mnt >> /mnt/etc/fstab


# Arch-chroot at /mnt
curl -o /mnt/install.sh https://raw.githubusercontent.com/josemapt/archpt/main/0-install.sh
chmod +x /mnt/install.sh

echo "Arch-chroot at /mnt"
arch-chroot /mnt