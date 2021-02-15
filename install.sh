#!/bin/bash

# Network checking ---------------------------------------------------------------
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
reflector --download-timeout 0.5 -f 70 -p https -p http --save /etc/pacman.d/mirrorlist 2>/dev/null

# variables -------------------------------------------------------------------
[[ -d /sys/firmware/efi ]] && EFI=true

read -p "Enter disk name (/dev/sda, /dev/nvme0n1): " DISK
read -p "Enter keyboard layout (us, es): " KEYBOARD

read -p "Enter hostname: " HOSTNAME

read -sp "Enter root password: " ROOTPASS
echo -e "\n"
read -p "Enter user name: " USERNAME
read -sp "Enter password for ${USERNAME}: " USERPASS
echo -e "\n"

# disk ------------------------------------------------------------------------
echo "==> Preparing disk for installation ..."

if [[ $EFI ]]
then
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
else
    echo "creating partition ${DISK}1 as ext4"
    parted ${DISK} mklabel msdos
    parted ${DISK} mkpart primary 1MiB 100%
    mkfs.ext4 ${DISK}1

    echo "mounting ${DISK}1 at /mnt"
    mount "${DISK}1" /mnt
fi


# Arch Linux installation -------------------------------------------------------------
echo "==> Installing linux..."
pacstrap /mnt base base-devel linux linux-firmware intel-ucode

echo "generating fstab"
genfstab -U /mnt >> /mnt/etc/fstab


# Arch-chroot at /mnt -----------------------------------------------------------------
#curl -o /mnt/install.sh https://raw.githubusercontent.com/josemapt/archpt/main/0-install.sh
#chmod +x /mnt/install.sh
#sed -i "s|DISK=|DISK=${DISK}|g" /mnt/install.sh

#echo "Arch-chroot at /mnt"
#arch-chroot /mnt

# vconsole -----------------------------------------------------------------------------
echo "==> Creating vconsole..."
echo "KEYMAP=${KEYBOARD}" > /mnt/etc/vconsole.conf


# Bootloader installation --------------------------------------------------------------
echo "==> Installing bootloader..."

if [[ $EFI ]]
then
    mkdir /mnt/boot/efi
    mount $DISK /mnt/boot/efi
    
    bootctl install --path=/mnt/boot/efi
    
    echo -e "default arch.conf\ntimeout 0\nconsole-mode max\neditor no" > /mnt/boot/efi/loader/loader.conf

    echo -e "title Arch Linux\nlinux /vmlinuz-linux\ninitrd  /intel-ucode.img\ninitrd  /initramfs-linux.img\noptions root=${DISK}p3 rw quiet splash loglevel=3 rd.udev.log_priority=3 vt.global_cursor_default=0" > /mnt/boot/efi/loader/entries/arch.conf

    cp -f /mnt/boot/i* /mnt/boot/efi/;
    cp -f /mnt/boot/vmlinuz-linux /mnt/boot/efi/;

    umount -R /mnt/boot/efi

else
    pacstrap /mnt grub
    arch-chroot /mnt "grub-install --target=i386-pc ${DISK}"
    arch-chroot /mnt "grub-mkconfig -o /boot/grub/grub.cfg"
fi


# Network configuration -----------------------------------------------------------------
echo "==> Configuring network..."

echo $HOSTNAME > /mnt/etc/hostname

echo -e "\n127.0.0.1	localhost\n::1		localhost\n127.0.1.1	${HOSTNAME}.localdomain	${HOSTNAME}" >> /mnt/etc/hosts

echo "installing networkmanager"
pacstrap /mnt networkmanager
arch-chroot /mnt "systemctl enable NetworkManager"

# Adding user -----------------------------------------------------------------------------
echo "==> Configuring users..."

arch-chroot /mnt "echo -e '${ROOTPASS}\n${ROOTPASS}' | passwd root"

arch-chroot /mnt "useradd -m ${USERNAME}"
arch-chroot /mnt "echo -e '${USERPASS}\n${USERPASS}' | passwd ${USERNAME}"

arch-chroot /mnt "usermod -aG wheel,audio,video,optical,storage ${USERNAME}"

sed -i 's/^# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /mnt/etc/sudoers


# Finish installation --------------------------------------------------------------------
echo "==> Downloading last pakages and cloning repo"
pacman -Sy --noconfirm git
git clone https://github.com/josemapt/archpt.git /mnt/home/${USERNAME}/archpt
chown -R ${USERNAME}:${USERNAME} /mnt/home/${USERNAME}/archpt

echo "==> Installation finished. System ready for first boot."