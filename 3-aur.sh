
echo "==> Installing paru aur helper..."
git clone "https://aur.archlinux.org/paru-bin.git"
cd paru-bin && makepkg --noconfirm -sic
cd ..
rm -rf paru-bin

echo "setting /tmp as build directory"
sudo sed -i '/^#NewsOnUpgrade/a BuildDir = \/tmp' /etc/paru.conf

echo "==> Installing aur pakages..."

paru -S --noconfirm <pakages_aur.txt

paru -S gdm-plymouth
sudo systemctl enable gdm