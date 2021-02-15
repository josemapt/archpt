
echo "==> Installing paru aur helper..."
git clone "https://aur.archlinux.org/paru-bin.git"
cd paru-bin && makepkg --noconfirm -sic
cd ..
rm -rf paru-bin

echo "setting /tmp as build directory"
sudo sed -i '/^#NewsOnUpgrade/a BuildDir = \/tmp' /etc/paru.conf

echo "==> Installing aur pakages..."

PKGS=(

    # --- programs
        'brave-bin'
        'vscodium-bin'
    
    # --- themes and fonts
        'yaru-sound-theme'
        'nerd-fonts-source-code-pro'
    
    # --- plymouth
        'plymouth'
        #'gdm-plymouth'
)

for PKG in "${PKGS[@]}"; do
    echo "INSTALLING: ${PKG}"
    paru -S --noconfirm "$PKG"
done

paru -S gdm-plymouth

sudo systemctl enable gdm