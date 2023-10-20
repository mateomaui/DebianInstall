#! /bin/bash

# if there is a root account, be sure to add [username] to sudoers group (from root), to give sudo root access to user.
# usermod -aG sudo [username]

# to edit or create this file:
# sudo nano debian-install-2-nvidia-add-i386-needs-reboot.sh

# to make executable, run this in terminal after you save it
# sudo chmod +x debian-install-2-nvidia-add-i386-needs-reboot.sh

# then to run:
# ./debian-install-2-nvidia-add-i386-needs-reboot.sh


# NOTE!! >>> STILL COMPLETELY UNTESTED

# I HAVE NO IDEA WHAT THIS REALLY DOES

# USE AT YOUR OWN RISK


cd ~

sudo apt update && sudo apt upgrade -y

# for nvidia drivers: add i386 architecture for 32-bit support (also needed for WINE and Steam)
# must be installed AFTER nvidia driver is already installed with 64-bit support
# AND REBOOTED ALREADY
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install libcuda1-i386 nvidia-driver-libs-i386 -y

# check installation:
nvidia-smi

#sudo reboot

