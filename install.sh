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
pacman -Sy --noconfirm wget
wget -q -o /etc/pacman.d/mirrorlist "https://archlinux.org/mirrorlist/?country=ES&protocol=http&protocol=https&ip_version=4"
wget -q -a /etc/pacman.d/mirrorlist "https://archlinux.org/mirrorlist/?country=DE&protocol=http&protocol=https&ip_version=4"
wget -q -a /etc/pacman.d/mirrorlist "https://archlinux.org/mirrorlist/?country=FR&protocol=http&protocol=https&ip_version=4"

sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist

# disk (mbr) ------------------------------------------------------------------------
echo "==> Preparing disk for installation (mbr)..."

echo -n "Enter disk name (/dev/sda, /dev/nvme0n1): "
read DISK

if [[ ! -d /sys/firmware/efi ]]
then
    echo "creating partition ${DISK}1 as ext4"
    parted ${DISK} mklabel msdos
    parted ${DISK} mkpart primary 1MiB 100%
    mkfs.ext4 ${DISK}1

    echo "mounting ${DISK}1 at /mnt"
    mount "${DISK}1" /mnt
else
    sgdisk -g ${DISK}

    if [[ $DISK = *nvme* ]]
    then
        echo "creating partition ${DISK}p1 as fat32"
        sgdisk -n 1:0:+550M ${DISK}
        sgdisk -t 1:ef00 ${DISK}
        mkfs.fat32 "${DISK}p1"

        echo "creating partition ${DISK}p2 as swap"
        sgdisk -n 2:0:+1G ${DISK}
        sgdisk -t 2:8200 ${DISK}
        mkswap "${DISK}p2"
        swapon "${DISK}p2"

        echo "creating partition ${DISK}p3 as ext4"
        sgdisk -n 3:0:0 ${DISK}
        sgdisk -t 3:8300 ${DISK}
        mkfs.ext4 "${DISK}p3"

        echo "mounting ${DISK}p3 at /mnt"
        mount "${DISK}p3" /mnt
    else
        echo "creating partition ${DISK}1 as fat32"
        sgdisk -n 1:0:+550M ${DISK}
        sgdisk -t 1:ef00 ${DISK}
        mkfs.fat32 "${DISK}1"

        echo "creating partition ${DISK}2 as swap"
        sgdisk -n 2:0:+1G ${DISK}
        sgdisk -t 2:8200 ${DISK}
        mkswap "${DISK}2"
        swapon "${DISK}2"

        echo "creating partition ${DISK}3 as ext4"
        sgdisk -n 3:0:0 ${DISK}
        sgdisk -t 3:8300 ${DISK}
        mkfs.ext4 "${DISK}3"

        echo "mounting ${DISK}3 at /mnt"
        mount "${DISK}3" /mnt
    fi
fi


# Arch Linux installation -------------------------------------------------------------
echo "==> Installing linux..."
pacstrap /mnt base base-devel linux linux-firmware intel-ucode

echo "generating fstab"
genfstab -U /mnt >> /mnt/etc/fstab


# Arch-chroot at /mnt -----------------------------------------------------------------
curl -o /mnt/install.sh https://raw.githubusercontent.com/josemapt/archpt/main/0-install.sh
chmod +x /mnt/install.sh
sed -i "s|DISK=|DISK=${DISK}|g" /mnt/install.sh

echo "Arch-chroot at /mnt"
arch-chroot /mnt