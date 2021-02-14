#!/bin/bash

# Some gnome settings -------------------------------------------




# theme ---------------------------------------------------------
thFile=".config/gtk-3.0/settings.ini"

echo "==> Starting theme configuration..."

[[ ! -d .config/gtk-3.0/ ]] && mkdir -p .config/gtk-3.0
[[ ! -f $thFile ]] && echo "[Settings]" > $thFile

echo "changing cursor theme"
tar -xf asetts/165371-Breeze.tar.gz
sudo mv Breeze/ /usr/share/icons/
echo "gtk-cursor-theme-name = Breeze" >> $thFile

echo "changing icon theme"
tar -xf asetts/papirus-icon-theme.tar.zst
sudo mv Breeze/ /usr/share/icons/
echo "gtk-cursor-theme-name = Breeze" >> $thFile