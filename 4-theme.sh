#!/bin/bash

# Some gnome settings -------------------------------------------




# theme ---------------------------------------------------------
echo "==> Starting theme configuration..."

[[ ! -d ~/.config/gtk-3.0/ ]] && mkdir -p ~/.config/gtk-3.0
[[ ! -f ~/.config/gtk-3.0/settings.ini ]] && echo "[Settings]" > ~/.config/gtk-3.0/settings.ini

echo "changing cursor theme"
tar -xf asetts/165371-Breeze.tar.gz
sudo mv Breeze/ /usr/share/icons/
echo "gtk-cursor-theme-name = Breeze" >> ~/.config/gtk-3.0/settings.ini
sudo sed -i 's/Adwaita/Breeze/' /usr/share/icons/default/index.theme

echo "changing icon theme"
tar -xf asetts/papirus-icon-theme.tar.zst
sudo mv usr/share/icons/Pa* /usr/share/icons/
echo "gtk-cursor-theme-name = Breeze" >> ~/.config/gtk-3.0/settings.ini