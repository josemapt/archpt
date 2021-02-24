
echo "==> Installing Base System..."

sudo pacman -S --noconfirm --needed neovim unzip fish man-db alsa-utils xdg-utils xcb-util-cursor bc fd exa ripgrep sd

if [[ $VBOX ]]
then
    sudo pacman -S --noconfirm --needed hsetroot
    
else
    sudo pacman -S --noconfirm --needed xf86-video-intel nvidia gnome-shell gnome-terminal gnome-control-center gnome-tweaks nautilus evince totem eog gnome-system-monitor file-roller baobab gnome-screenshot
fi

echo "==> Installing paru aur helper..."
git clone "https://aur.archlinux.org/paru-bin.git"
cd paru-bin && makepkg --noconfirm -sic
cd ..
rm -rf paru-bin

echo "setting /tmp as build directory"
sudo sed -i '/^#NewsOnUpgrade/a BuildDir = \/tmp' /etc/paru.conf


echo "==> Installing aur pakages..."

paru -S --noconfirm brave-bin vscodium-bin nerd-fonts-source-code-pro

if [[ $VBOX ]]
then
    #sudo pacman -S --noconfirm lightdm
    #paru -S --noconfirm lightdm-mini-greeter
    #
    #sudo sed -i "s/^#greeter-session=/greeter-session=lightdm-mini-greeter/" /etc/lightdm/lightdm.conf
    #sudo sed -i "s/CHANGE_ME/$(whoami)/" /etc/lightdm/lightdm-mini-greeter.conf
    #
    #sudo systemctl enable lightdm
else
    paru -S plymouth pamac-aur yaru-sound-theme gdm-plymouth
    sudo systemctl enable gdm
fi