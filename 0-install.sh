#!/bin/bash

DISK= # this is added when runing the fisrt script

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

if [[ $DISK = *nvme* ]]
then
    mkdir /boot/efi
    mount $DISK /boot/efi
    
    bootctl install --path=/boot/efi
    cat <<EOF > /boot/efi/loader/entries/loader.conf
    default arch.conf
    timeout 0
    console-mode max
    editor no
    EOF

    cat <<EOF > /boot/efi/loader/entries/arch.conf
    title Arch Linux  
    linux /vmlinuz-linux  
    initrd  /intel-ucode.img
    initrd  /initramfs-linux.img  
    options root=${DISK}p3 rw quiet splash loglevel=3 rd.udev.log_priority=3 vt.global_cursor_default=0
    EOF

    umount -R /boot/efi

else
    pacman -S --noconfirm grub
    grub-install --target=i386-pc $DISK
    grub-mkconfig -o /boot/grub/grub.cfg
fi


# Network configuration -----------------------------------------------------------------
echo "==> Configuring network..."

echo -n "Enter hostname: "
read HOSTNAME
echo $HOSTNAME > /etc/hostname

echo -e "\n127.0.0.1	localhost\n::1		localhost\n127.0.1.1	${HOSTNAME}.localdomain	${HOSTNAME}" >> /etc/hosts

echo "installing networkmanager"
pacman -S --noconfirm networkmanager
systemctl enable NetworkManager


# Adding user -----------------------------------------------------------------------------
echo "==> Configuring users..."

echo "enter root password"
passwd

echo -n "enter username: "
read USERNAME

useradd -m $USERNAME
passwd $USERNAME
usermod -aG wheel,audio,video,optical,storage $USERNAME

sed -i 's/^# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers


# Finish installation --------------------------------------------------------------------
echo "==> Downloading last pakages and cloning repo"
pacman -S --noconfirm git
git clone https://github.com/josemapt/archpt.git /home/$USERNAME/


echo "==> Installation finished. System ready for first boot. Shutting down machine..."
rm install.sh