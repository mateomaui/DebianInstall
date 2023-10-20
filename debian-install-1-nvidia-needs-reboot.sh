#! /bin/bash

# if there is a root account, be sure to add [username] to sudoers group (from root), to give sudo root access to user.
# usermod -aG sudo [username]

# to edit:
# sudo nano debian-install-1-nvidia-needs-reboot.sh

# to make executable, run this in terminal after you save it
# sudo chmod +x debian-install-1-nvidia-needs-reboot.sh

# then to run:
# ./debian-install-1-nvidia-needs-reboot.sh


# NOTE!! >>> STILL COMPLETELY UNTESTED

# I HAVE NO IDEA WHAT THIS REALLY DOES

# IT INCLUDES SOME DEPENDENCIES AND REPOS THAT MAY NOT NEED TO BE HERE, INTENDED FOR "debian-install-3-apps-or-no-nvidia.sh"

# USE AT YOUR OWN RISK

cd ~

sudo apt update && sudo apt upgrade -y

# install dependencies needed for Steam install etc, and for adding repositories
sudo apt-get -y install software-properties-common software-properties-gtk apt-transport-https dirmngr ca-certificates dkms curl

# remove any previous nVidia
sudo apt autoremove nvidia* --purge
sudo /usr/bin/nvidia-uninstall
sudo /usr/local/cuda-X.Y/bin/cuda-uninstall

# add repositories for everything needed - STILL NEEDS A MANUAL CONFIRMATION
# nvidia repository
curl -fSsL https://developer.download.nvidia.com/compute/cuda/repos/debian11/x86_64/3bf863cc.pub | sudo gpg --dearmor | sudo tee /usr/share/keyrings/nvidia-drivers.gpg > /dev/null 2>&1
sudo tee /etc/apt/sources.list.d/nvidia-drivers.list
# for winetricks
sudo add-apt-repository "deb http://ftp.us.debian.org/debian bookworm main contrib"
sudo add-apt-repository contrib non-free non-free-firmware


sudo apt update && sudo apt upgrade -y

# NVIDIA INSTALL ...

# ... from debian repository (not updated as quickly):
#sudo apt install linux-headers-amd64 -y
#sudo apt install nvidia-detect -y
#nvidia-detect
#sudo apt install nvidia-driver linux-image-amd64 -y

# ... or ...

# ... from nVidia repository (always the current update):
# ... proprietary:
sudo apt install nvidia-driver cuda nvidia-smi nvidia-settings -y
# ... or opensource:
#sudo apt install nvidia-driver nvidia-kernel-open-dkms cuda nvidia-smi nvidia-settings -y
# ... then to check installation:
nvidia-smi

#sudo reboot now
