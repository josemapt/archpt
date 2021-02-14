# archpt
Script for arch linux installation

### Usage
This script needs network connection and the disk must be partitioned.

Then run:
    curl -O https://raw.githubusercontent.com/josemapt/archpt/main/install.sh

    chmod +x install.sh

    ./install.sh

This script will install linux and chroot into it. Then run again <b>./install.sh</b> and wait.

After rebooting you'll see that the home directory is not empty. Then cd into archpt and run:

    make
    ./archpt.sh
