
echo "==> Starting theme configuration..."

echo "changing keymap"
gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'es')]"

echo "changing cursor theme"
tar -xf assets/165371-Breeze.tar.gz
sudo mv Breeze/ /usr/share/icons/
gsettings set org.gnome.desktop.interface cursor-theme 'Breeze'
sudo sed -i 's/Adwaita/Breeze/' /usr/share/icons/default/index.theme

echo "changing icon theme"
tar -xf assets/papirus-icon-theme.tar.zst
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

echo "changing plymouth theme"
sudo mv plymouth/custom /usr/share/plymouth/themes
sudo plymouth-set-default-theme -R custom

if [[ ! -d /sys/firmware/efi ]]
then
    sudo sed -i 's/HOOKS=(base udev autodetect modconf block filesystems keyboard fsck)/HOOKS=(base udev plymouth autodetect modconf block filesystems keyboard fsck)/' /etc/mkinitcpio.conf
    sudo mkinitcpio -P

    sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet"/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash loglevel=3 rd.udev.log_priority=3 vt.global_cursor_default=0"/' /etc/default/grub
    sudo grub-mkconfig -o /boot/grub/grub.cfg
fi

#sudo mount /dev/nvme0n1p1 /boot/efi/;
#sudo cp -f /boot/i* /boot/efi/;
#sudo cp -f /boot/vmlinuz-linux /boot/efi/;
#sudo sudo umount -R /boot/efi;


echo "changing default shell"
sudo chsh -s /bin/fish josema


echo "Installation finished"