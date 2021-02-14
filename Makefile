all: archpt.sh

archpt.sh: 1-setup.sh 2-base.sh 3-arch.sh 4-theme.sh
	cat 1-setup.sh 2-base.sh 3-arch.sh 4-theme.sh > archpt.sh
	chmod +x archpt.sh