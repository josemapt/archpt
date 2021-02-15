
echo "==> Installing Base System..."

PKGS=(

    # --- drivers and utils
        'xf86-video-intel'
        'nvidia'
        'neovim'
        'unzip'
        'fish'
        'fd'
        'exa'
        'ripgrep'
        'sd'

    # --- desktop enviroment
        'gnome-shell'
        'gnome-terminal'
        'gnome-control-center'
        'gnome-tweaks'
        #'gdm'

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