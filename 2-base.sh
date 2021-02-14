
echo "==> Installing Base System..."

PKGS=(

    # --- drivers and utils
        'xf86-video-intel'
        'nvidea'
        'neovim'
        'unzip'
        'fish'

    # --- desktop enviroment
        'gnome-shell'
        'gnome-terminal'
        'gnome-control-center'
        'gnome-tweaks'
        'gdm'

    # --- programs
        'nautilus'
        'evince'
        'totem'
        'eog'
        'gnome-system-monitor'
        'file-roller'
        'baobab'
        'gnome-screenshot'
)

for PKG in "${PKGS[@]}"; do
    echo "INSTALLING: ${PKG}"
    sudo pacman -S "$PKG" --noconfirm --needed
done

# some gnome settings -------------------------------------------
sudo systemctl enable gdm

gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'es')]"