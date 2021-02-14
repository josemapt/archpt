
echo "==> Starting theme configuration..."

echo "changing cursor theme"
tar -xf asetts/165371-Breeze.tar.gz
sudo mv Breeze/ /usr/share/icons/
gsettings set org.gnome.desktop.interface cursor-theme 'Breeze'
sudo sed -i 's/Adwaita/Breeze/' /usr/share/icons/default/index.theme

echo "changing icon theme"
tar -xf asetts/papirus-icon-theme.tar.zst
sudo mv usr/share/icons/Pa* /usr/share/icons/
gsettings set org.gnome.desktop.interface icon-theme 'Papirus'

echo "changing gtk theme"
tar -xf assets/Matcha-sea.tar.gz
sudo mv usr/share/themes/Matcha-* /usr/share/themes/
gsettings set org.gnome.desktop.interface gtk-theme 'Matcha-sea'

echo "changing background image"
sudo mkdir /usr/share/backgrounds
sudo mv assets/wall1.jpg /usr/share/backgrounds
gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/wall1.jpg'

echo "changing sound theme"
gsettings set org.gnome.desktop.sound theme-name 'Yaru'

echo "adding icons to sidepanel"
gsettings set org.gnome.shell favorite-apps "['brave-browser.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'VSCodium.desktop']"

echo "changing default shell"
sudo chsh -s /bin/fish josema


echo "Installation finished"