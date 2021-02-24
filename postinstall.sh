#!/bin/bash

cat 1-setup.sh 2-base.sh 3-theme.sh > archpt.sh
chmod +x archpt.sh
./archpt.sh

echo "cleaning up"
rm -f .bash_*

echo "Installation finished"
rm -rf ~/archpt