#!/bin/bash

cd ~/archpt

cat 1-setup.sh 2-base.sh 3-aur.sh 4-theme.sh > archpt.sh
chmod +x archpt.sh
./archpt.sh