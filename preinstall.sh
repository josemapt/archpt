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
#timedatectl set-ntp true
curl -o mirrorlist_spain https://archlinux.org/mirrorlist/?country=ES&protocol=http&protocol=https&ip_version=4
curl -o mirrorlist_germany https://archlinux.org/mirrorlist/?country=DE&protocol=http&protocol=https&ip_version=4
curl -o mirrorlist_france https://archlinux.org/mirrorlist/?country=FR&protocol=http&protocol=https&ip_version=4

cat mirrorlist_spain mirrorlist_france mirrorlist_germany > /etc/pacman.d/mirrorlist

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
mount "/dev/${DISK}2" /mnt


# Arch Linux installation -------------------------------------------------------------
echo "==> Installing linux..."
pacstrap /mnt base base-devel linux linux-firmware intel-ucode

echo "generating fstab"
genfstab -U /mnt >> /mnt/etc/fstab

echo "Arch-chroot at /mnt"
arch-chroot /mnt


# Initial config ----------------------------------------------------------------------
echo "==> Setting zoneinfo..."
ln -sf /usr/share/zoneinfo/Europe/Madrid /etc/localtime
hwclock --systohc

echo "==> Generating locales..."
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
locale-gen

echo "==> Creating vconsole..."
echo "KEYMAP=es" > /etc/vconsole.conf


# Bootloader installation --------------------------------------------------------------
echo "==> Installing bootloader..."
pacman -S grub dosfstools mtools
grub-install --target=i386-pc ${DISK}2
grub-mkconfig -o /boot/grub/grub.cfg


# Network configuration -----------------------------------------------------------------
echo "==> Configuring network..."

echo -n "Enter hostname: "
read HOSTNAME
echo $HOSTNAME > /etc/hostname

echo -e "\n127.0.0.1	localhost\n::1		localhost\n127.0.1.1	jm-arch.localdomain	jm-arch" >> /etc/hosts

echo "installing networkmanager"
pacman -S networkmanager
systemctl enable NetworkManager


# Adding user -----------------------------------------------------------------------------
echo "==> Configuring users..."

echo "enter root password"
passwd

echo "enter username: "
read USERNAME

useradd -m $USERNAME
passwd $USERNAME
usermod -aG wheel,audio,video,optical,storage $USERNAME

sed -i 's/^# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers


# Finish installation
echo "==> Installation finished. System ready for first boot. Shutting down machine..."
exit
umount -R /mnt
shutdown now