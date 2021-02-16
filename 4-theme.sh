
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
sudo mkdir /usr/share/images
sudo cp ~/archpt/plymouth/custom/logo.png /usr/share/images # logo for gdm
sudo mv assets/wall1.jpg /usr/share/images
gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/images/wall1.jpg'

echo "changing sound theme"
gsettings set org.gnome.desktop.sound theme-name 'Yaru'

echo "adding icons to sidepanel"
gsettings set org.gnome.shell favorite-apps "['brave-browser.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'VSCodium.desktop']"

echo "changing plymouth theme"
sudo mv plymouth/custom /usr/share/plymouth/themes
sudo plymouth-set-default-theme -R custom

sudo sed -i 's/MODULES=()/MODULES=(i915)/' /etc/mkinitcpio.conf
sudo sed -i 's/HOOKS=(base udev autodetect modconf block filesystems keyboard fsck)/HOOKS=(base udev plymouth autodetect modconf block filesystems keyboard fsck)/' /etc/mkinitcpio.conf
sudo mkinitcpio -P

if [[ ! -d /sys/firmware/efi ]]
then
    sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet"/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash loglevel=3 rd.udev.log_priority=3 vt.global_cursor_default=0"/' /etc/default/grub
    sudo grub-mkconfig -o /boot/grub/grub.cfg
fi

echo "changing <close> keybinding"
gsettings set org.gnome.desktop.wm.keybindings close "['<Super><Shift>q']"

echo "removing innecesary desktop entries"
sudo bash -c "echo 'NoDisplay=true'  >> /usr/share/applications/nvim.desktop"
sudo bash -c "echo 'NoDisplay=true'  >> /usr/share/applications/bssh.desktop"
sudo bash -c "echo 'NoDisplay=true'  >> /usr/share/applications/avahi-discover.desktop"
sudo bash -c "echo 'NoDisplay=true'  >> /usr/share/applications/bvnc.desktop"
sudo bash -c "echo 'NoDisplay=true'  >> /usr/share/applications/qv4l2.desktop"
sudo bash -c "echo 'NoDisplay=true'  >> /usr/share/applications/qvidcap.desktop"
sudo bash -c "echo 'NoDisplay=true'  >> /usr/share/applications/lstopo.desktop"
sudo bash -c "echo 'NoDisplay=true'  >> /usr/share/applications/nm-connection-editor.desktop"

echo "changing terminal theme"
gsettings set org.gnome.Terminal.Legacy.Settings theme-variant 'dark'
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ font 'SauceCodePro Nerd Font 22'

echo  "changing gdm theme"
sudo machinectl shell gdm@ /bin/bash -c "gsettings set org.gnome.desktop.interface cursor-theme 'Breeze'"
sudo machinectl shell gdm@ /bin/bash -c "gsettings set org.gnome.desktop.interface icon-theme 'Papirus'"
sudo machinectl shell gdm@ /bin/bash -c "gsettings set org.gnome.desktop.interface gtk-theme 'Matcha-sea'"
sudo machinectl shell gdm@ /bin/bash -c "gsettings set org.gnome.login-screen logo '/usr/share/images/logo.png'"
sudo machinectl shell gdm@ /bin/bash -c "gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click 'true'"
sudo machinectl shell gdm@ /bin/bash -c "gsettings set org.gnome.desktop.interface toolkit-accessibility 'false'"

echo "moving config files"
mkdir -p ~/.cache/bash

mv -f ~/archpt/config/.bashrc ~
mv -f ~/archpt/config/nvim ~/.config/
mv -f ~/archpt/config/fish/* ~/.config/fish/
mv -f ~/archpt/config/mimeapps.list ~/.config/

echo "changing default shell"
sudo chsh -s /bin/fish $(whoami)
/bin/fish -c "set -U fish_greeting"