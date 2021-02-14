
echo "==> Installing paru aur helper..."
git clone "https://aur.archlinux.org/paru-bin.git"
cd paru-bin && makepkg --noconfirm -sic
cd ..
rm -rf paru-bin

echo "==> Installing aur pakages..."

PKGS=(

    # --- programs
        'brabe-bin'
        'vscodium-bin'
    
    # --- themes and fonts
        'yaru-sound-theme'
        'nerd-fonts-source-code-pro'
)

for PKG in "${PKGS[@]}"; do
    echo "INSTALLING: ${PKG}"
    paru -S --noconfirm "$PKG"
done