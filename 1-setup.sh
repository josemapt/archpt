#!/bin/bash

# Network and mirrorlist --------------------------------------------------------------
echo "==> Checking network connection..."
if ping -c 1 google.com >/dev/null
then
    echo "done"
else
    echo "Network not found"
    read -p "Enter wifi SSID: " SSID
    read -ps "Enter password for $SSID: " PASS
    
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

echo "==> Refreshing mirrorlist (spain)..."
#timedatectl set-ntp true
curl -s -o mirrorlist_spain https://archlinux.org/mirrorlist/?country=ES&protocol=http&protocol=https&ip_version=4
curl -s -o mirrorlist_germany https://archlinux.org/mirrorlist/?country=DE&protocol=http&protocol=https&ip_version=4
curl -s -o mirrorlist_france https://archlinux.org/mirrorlist/?country=FR&protocol=http&protocol=https&ip_version=4

cat mirrorlist_spain mirrorlist_france mirrorlist_germany > /etc/pacman.d/mirrorlist
sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist


# makepkg config ----------------------------------------------------------------------
echo "==> Configuring makepkg..."

nc=$(grep -c ^processor /proc/cpuinfo)

echo "changing the makeflags for $nc cores."
sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j$nc"/g' /etc/makepkg.conf

echo "changing the compression settings for $nc cores."
sudo sed -i 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T $nc -z -)/g' /etc/makepkg.conf