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

echo "==> Mounting /dev/nvme0n1p3 at /mnt..."
mount /dev/nvme0n1p3 /mnt
echo "done"

echo "==> Installing base pakages..."
pacstrap /mnt base base-devel linux linux-firmware
echo "done"

echo "==> Generating fstab..."
genfstab -U /mnt >> /mnt/etc/fstab
echo "done"

echo "==> Downloading install script"
curl -O https://raw.githubusercontent.com/josemapt/archpt/main/install.sh
cp install.sh /mnt
echo "done"

echo "==> Arch-chroot at /mnt"
arch-chroot /mnt