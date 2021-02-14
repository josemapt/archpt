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

echo "==> Refreshing mirrorlist..."
timedatectl set-ntp true
reflector --latest 200 --protocol http --protocol https --sort rate --save /etc/pacman.d/mirrorlist &

# disk (mbr) ------------------------------------------------------------------------
echo "==> Preparing disk for installation (mbr)..."

echo -n "Enter disk name (/dev/sda, /dev/nvme0n1 ...): "
read DISK

echo "formating ${DISK}1 as linux swap"
mkswap "${DISK}1"
swapon "${DISK}1"

echo "formating ${DISK}2 as ext4"
mkfs.ext4 "${DISK}2"

echo "mounting ${DISK}2 at /mnt"
mount /dev/nvme0n1p3 /mnt


# Arch Linux installation -------------------------------------------------------------
echo "==> Installing linux..."
pacstrap /mnt base base-devel linux linux-firmware intel-ucode

echo "generating fstab"
genfstab -U /mnt >> /mnt/etc/fstab

echo "Arch-chroot at /mnt"
arch-chroot /mnt


# Bootloader installation --------------------------------------------------------------
echo "==> Installing bootloader..."
mkdir /boot/efi/
mount "${DISK}1" /boot/

bootctl install
cat <<EOF > /boot/loader/entries/arch.conf
title Arch Linux  
linux /vmlinuz-linux  
initrd  /intel-ucode.img
initrd  /initramfs-linux.img  
options root=${DISK}2 rw
EOF