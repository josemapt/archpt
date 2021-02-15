#!/bin/bash

# Network ------------------------------------------------------------------
echo "==> Checking network connection..."
if ping -c 1 google.com >/dev/null
then
    echo "done"
else
    echo "Network not found"
    read -p "Enter wifi SSID: " SSID
    read -sp "Enter password for $SSID: " PASS
    
    nmcli r wifi on
    nmcli d wifi connect $SSID password $PASS

    if ping -c 1 google.com >/dev/null
    then
        echo "done"
    else
        echo "Network not found"
        exit -1
    fi
fi

# pacman config --------------------------------------------------------------------
echo "adding color to pacman"
sudo sed -i 's/#Color/Color/' /etc/pacman.conf

# makepkg config ----------------------------------------------------------------------
echo "==> Configuring makepkg..."

nc=$(grep -c ^processor /proc/cpuinfo)

echo "changing the makeflags for $nc cores."
sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j$nc"/g' /etc/makepkg.conf

echo "changing the compression settings for $nc cores."
sudo sed -i 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T $nc -z -)/g' /etc/makepkg.conf