#! /bin/bash

# if there is a root account, be sure to add [username] to sudoers group (from root), to give sudo root access to user.
# NOTE >> Some things cannot be installed as "root", be logged in as someone other than root (but with root access) before running this.
# usermod -aG sudo [username]

# to edit or create this file:
# sudo nano debian-install-3-apps-or-no-nvidia.sh

# to make executable, run this in terminal after you save it
# sudo chmod +x debian-install-3-apps-or-no-nvidia.sh

# or to make all "debian-install-" files executable at once
# sudo chmod +x debian-install-*.sh

# then to run:
# ./debian-install-3-apps-or-no-nvidia.sh

# it will then:
#  - initial apt update & upgrade
#  - install dependencies necessary for all other installations, repo additions, etc
#  - add repositories
# >>>> - YOU MUST HIT "ENTER" FOR THESE TO CONTINUE
#  - install display manager "gdm3"
# >>>> - YOU MUST CHOOSE A DISPLAY MANAGER TO CONTINUE
#  - install desktop environment "cinnamon"
#  - install desktop environment "kde-plasma-desktop" (minimal install)
#  - add i386 architecture support (needed for Steam and Wine)
#    - update repos for i386 support
#  - install flatpak and store plugins <-- COMMENT OUT/DELETE FOR LINUX MINT DEBIAN EDITION
#  - remove Firefox ESR (v115) <-- COMMENT OUT/DELETE FOR LINUX MINT DEBIAN EDITION
#  - add repos for latest Firefox <-- COMMENT OUT/DELETE FOR LINUX MINT DEBIAN EDITION
#  - install latest Firefox (firefox-mozilla-build) <-- COMMENT OUT/DELETE FOR LINUX MINT DEBIAN EDITION
#  - add repos for wine
#  - install wine
#    - run winecfg (for initial files setup)
# >>>>   - YOU MUST CLICK THE BUTTON TO UPDATE, AND THEN CHOOSE YOUR WINDOWS VERSION AND SAVE TO CONTINUE
#  - install winetricks (repo added earlier)
#    - run winetricks (for initial files setup)
# >>>>   - YOU MUST "CANCEL" AFTER IT IS RUNNING TO CONTINUE
#  - add repos for Steam
#  - install Steam
#    - run Steam (for initial setup, so directories are available for installing a plugin afterward)
# >>>> - YOU MUST WAIT FOR IT TO FINISH UPDATING, THEN EXIT THE APP ONCE YOU CAN SEE THE QR CODE TO CONTINUE
#  - removes two unnecessary Steam repo sources
#  - install dependencies for Boxtron (Steam compatibility plugin)
#  - create directory in Steam for compatibilitytools.d, move into that directory
#  - install Boxtron v0.5.4 (need to edit this script to install a different version)
#  - install dependencies for Protontricks
#  - install protontricks with pipx, set environment path
#  - add dependencies and repos for Librewolf
#  - install latest Librewolf
#  - install latest Mullvad Browser, and set as system default
#  - install Tor Browser v13.0 (need to edit script for a different version)
#  - add repos for darktable
#  - install darktable
#  - install gimp
#      - install Diolinux's PhotoGIMP to give it a Photoshop GUI
#  - install krita
#  - install scribus
#  - install inkscape
#  - install rawtherapee
#  - install audacity
#  - install ffmpeg
#  - install obs-studio
#  - install pikopixel.app
#  - install digikam
#  - install kdenlive
#  - install xournalpp
#  - install deluge
#  - install playonlinux
#  - install Joplin
#  - install Minigalaxy (thin GOG client)
#    - use cat >> to make "minigalaxy-login.sh" shortcuts to the Desktop and user's home directory to load Minigalaxy using a "WEBKIT_DISABLE_COMPOSITING_MODE=1" fix for a bug that prevents the login window content from showing. After login, you shouldn't have to use these shortcuts again, and can launch Minigalaxy normally, unless you get logged out.
#      - use chmod to make the shortcuts executable
#  - install Lutris
#  - install Heroic Games Launcher v2.9.2 (need to edit the script for a different version)
#  - install VMWare Workstation Player 17.0.2 (need to edit the script for a different version)
#  - if installing this inside a VM: (need to remove or comment out manually if not)
#    - install fix vmware-tools-patches (fixes the ability to share folders between guest and host OSs)
#    - removes vmware-tools-patches install folder
#    - temporarily use vmhgfs-fuse to mount the folders to /mnt/hgfs/
#      - must manually update /etc/fstab to make it permanent, adding to the end:
#        .host:/    /mnt/hgfs/    fuse.vmhgfs-fuse    defaults,allow_other,uid=1000     0    0
#  - install VirtualBox 7.0 (must edit this script for a different version)
#    - runs vboxmanage to output the precise version of VirtualBox installed, saves to $VirtualBoxVersion variable
#    - downloads extension pack for current version using $VirtualBoxVersion in paths
#    - adds user to group vboxusers
#    - removes extension pack download
#  - install alien (rpm package compatibility)
#    - use as "sudo alien -d package-name.rpm" to convert .rpm to .deb
#    - then install "sudo dpkg -i package-name.deb"
#  - install snapd and Snap Store (TAKES A REALLY LONG TIME)
# >>>> - YOU MUST HIT "ENTER" WHEN DONE TO CONTINUE
#  - one final apt update and upgrade
#  - apt clean and reboot

cd ~
sudo apt update && sudo apt upgrade -y
# install dependencies needed for Steam install etc, and for adding repositories
sudo apt-get -y install software-properties-common software-properties-gtk apt-transport-https dirmngr ca-certificates dkms curl git
# add repositories - STILL NEEDS A MANUAL CONFIRMATION
sudo add-apt-repository contrib non-free
# still must be installed even if no nVidia drivers, for Wine and Steam support
# (no issues if it's run a second time)
sudo dpkg --add-architecture i386
sudo apt update

# install KDE Plasma - NEEDS A MANUAL CONFIRMATION
sudo apt-get -y install kde-plasma-desktop
# install gdm3 display manager - NEEDS A MANUAL CONFIRMATION
sudo apt-get -y install gdm3
# install Cinnamon Desktop Environment
sudo apt-get -y install cinnamon-desktop-environment

###############################################################
#
#  DISABLE/COMMENT OUT/DELETE EVERYTHING IN THIS SECTION 
#    FOR 
#  >>> LINUX MINT DEBIAN EDITION (LMDE) <<<
#
###############################################################
# install Flatpak services
# https://www.linuxcapable.com/how-to-install-flatpak-on-debian-linux/
sudo apt-get -y install flatpak
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo apt-get -y install gnome-software-plugin-flatpak

# >> DISABLE/COMMENT OUT << FOR LINUX MINT DEBIAN EDITION (LMDE)
# remove Firefox ESR
sudo apt purge firefox-esr -y
# install latest version Firefox
sudo mkdir /etc/apt/keyrings/
sudo gpg --keyserver keyserver.ubuntu.com --recv-keys 2667CA5C
sudo gpg -ao ~/ubuntuzilla.gpg --export 2667CA5C
cat ubuntuzilla.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/ubuntuzilla.gpg
sudo rm ~/ubuntuzilla.gpg
echo "deb [signed-by=/etc/apt/keyrings/ubuntuzilla.gpg] http://downloads.sourceforge.net/project/ubuntuzilla/mozilla/apt all main" | sudo tee /etc/apt/sources.list.d/ubuntuzilla.list > /dev/null
sudo apt update
sudo apt-get -y install firefox-mozilla-build
###############################################################
#
#  END REMOVAL SECTION FOR LINUX MINT DEBIAN EDITION (LMDE)
#
###############################################################


# Wine and winetricks - NEEDS A MANUAL CONFIRMATION
# https://www.linuxcapable.com/how-to-install-wine-on-debian-linux/
# sudo dpkg --add-architecture i386
curl -fSsL https://dl.winehq.org/wine-builds/winehq.key | gpg --dearmor | sudo tee /usr/share/keyrings/winehq.gpg > /dev/null
# The line below is commented out, as the "$(lsb_release -cs)" portion returns "faye" on Linux Mint Debian Edition, and there is no winehq.org repo for that name.
# Until an automated fix is found, just overriding it with a static "bookworm" identifier for Debian 12.
# echo deb [signed-by=/usr/share/keyrings/winehq.gpg] http://dl.winehq.org/wine-builds/debian/ $(lsb_release -cs) main | sudo tee /etc/apt/sources.list.d/winehq.list
echo deb [signed-by=/usr/share/keyrings/winehq.gpg] http://dl.winehq.org/wine-builds/debian/ bookworm main | sudo tee /etc/apt/sources.list.d/winehq.list
sudo apt update
sudo apt-get -y install winehq-stable --install-recommends
winecfg
# install the add-on for winecfg when prompted
# when the main winecfg screen appears, just select the type of Windows (Windows 10) and hit OK to continue for now
sudo apt-get -y install winetricks

# install GIMP
sudo apt-get -y install gimp
gimp
# EXIT GIMP AFTER IT LOADS TO CONTINUE

# install Diolinux's PhotoGIMP plugin to give GIMP a Photoshop GUI
wget https://github.com/Diolinux/PhotoGIMP/releases/download/1.1/PhotoGIMP.zip
unzip PhotoGIMP.zip
sudo rm PhotoGIMP.zip
sudo cp -R PhotoGIMP-master/.var/app/org.gimp.GIMP/config/GIMP/2.10/* $HOME/.config/GIMP/2.10/
sudo rm -rf PhotoGIMP-master

# install VirtualBox
wget -O- -q https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo gpg --dearmour -o /usr/share/keyrings/oracle_vbox_2016.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/oracle_vbox_2016.gpg] http://download.virtualbox.org/virtualbox/debian bookworm contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
sudo apt update
sudo apt-get -y install virtualbox-7.0
VirtualBoxVersion=$(vboxmanage -v | cut -dr -f1)
wget https://download.virtualbox.org/virtualbox/$VirtualBoxVersion/Oracle_VM_VirtualBox_Extension_Pack-$VirtualBoxVersion.vbox-extpack
# ---> MANUAL CONFIRMATION NEEDED HERE
sudo vboxmanage extpack install Oracle_VM_VirtualBox_Extension_Pack-$VirtualBoxVersion.vbox-extpack
sudo usermod -a -G vboxusers $USER
rm -rf Oracle_VM_VirtualBox_Extension_Pack-$VirtualBoxVersion.vbox-extpack

# Steam
# https://www.linuxcapable.com/how-to-install-steam-on-debian-linux/
# sudo dpkg --add-architecture i386
curl -s http://repo.steampowered.com/steam/archive/stable/steam.gpg | sudo tee /usr/share/keyrings/steam.gpg > /dev/null
echo deb [arch=amd64,i386 signed-by=/usr/share/keyrings/steam.gpg] http://repo.steampowered.com/steam/ stable steam | sudo tee /etc/apt/sources.list.d/steam.list
sudo apt update
sudo apt-get -y install \
  libgl1-mesa-dri:amd64 \
  libgl1-mesa-dri:i386 \
  libgl1-mesa-glx:amd64 \
  libgl1-mesa-glx:i386 \
  steam-launcher
# run Steam to create default local profiles and update
steam
# CLOSE STEAM MANUALLY TO CONTINUE INSTALL SCRIPT, DON'T LOGIN HERE FOR NOW
# remove the two extra Steam sources
sudo rm /etc/apt/sources.list.d/steam-beta.list
sudo rm /etc/apt/sources.list.d/steam-stable.list

sudo apt-get -y install dosbox inotify-tools timidity fluid-soundfont-gm
mkdir ~/.local/share/Steam/compatibilitytools.d
cd ~/.local/share/Steam/compatibilitytools.d
curl -L https://github.com/dreamer/boxtron/releases/download/v0.5.4/boxtron.tar.xz | tar xJf -
cd ~

sudo apt-get -y install python3-pip python3-setuptools python3-venv pipx
pipx install protontricks
pipx ensurepath

# install Librewolf
# https://librewolf.net/installation/debian/
sudo apt update && sudo apt install -y wget gnupg lsb-release apt-transport-https ca-certificates
distro=$(if echo " una bookworm vanessa focal jammy bullseye vera uma " | grep -q " $(lsb_release -sc) "; then lsb_release -sc; else echo bookworm; fi)
wget -O- https://deb.librewolf.net/keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/librewolf.gpg
sudo tee /etc/apt/sources.list.d/librewolf.sources << EOF > /dev/null
Types: deb
URIs: https://deb.librewolf.net
Suites: $distro
Components: main
Architectures: amd64
Signed-By: /usr/share/keyrings/librewolf.gpg
EOF
sudo apt update
sudo apt-get -y install librewolf

# install Mullvad Browser (current)
cd ~/.local/share && wget https://mullvad.net/en/download/browser/linux-x86_64/latest -O mullvad-browser.tar.xz
tar -xvf mullvad-browser.tar.xz mullvad-browser
rm mullvad-browser.tar.xz && cd mullvad-browser
./start-mullvad-browser.desktop --register-app --setDefaultBrowser
# to uninstall:
# cd ~/.local/share/mullvad-browser && ./start-mullvad-browser.desktop --unregister-app
# cd ~
# rm -rf ~/.local/share/mullvad-browser
cd ~

# install Tor Browser 13.0 (regular package is broken)
# https://www.linuxcapable.com/how-to-install-tor-browser-on-debian-linux/
TorBrowserVersion="13.0"
wget https://dist.torproject.org/torbrowser/$TorBrowserVersion/tor-browser-linux-x86_64-$TorBrowserVersion.tar.xz
tar -xvJf tor-browser-linux-x86_64-$TorBrowserVersion.tar.xz
rm tor-browser-linux-x86_64-$TorBrowserVersion.tar.xz
sudo rm -rf ~/.local/share/tor-browser
sudo mv -f tor-browser ~/.local/share/
cd ~/.local/share/tor-browser
./start-tor-browser.desktop --register-app
# to uninstall:
# cd ~/.local/share/tor-browser && ./start-tor-browser.desktop --unregister-app
# cd ~
# rm -rf ~/.local/share/tor-browser
cd ~


# install darktable
echo 'deb http://download.opensuse.org/repositories/graphics:/darktable/Debian_12/ /' | sudo tee /etc/apt/sources.list.d/graphics:darktable.list
curl -fsSL https://download.opensuse.org/repositories/graphics:darktable/Debian_12/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/graphics_darktable.gpg > /dev/null
sudo apt update
sudo apt-get -y install darktable

# install other apps that don't need specific repos added
sudo apt-get -y install krita
sudo apt-get -y install scribus scribus-template icc-profiles-free
sudo apt-get -y install inkscape
sudo apt-get -y install rawtherapee
sudo apt-get -y install audacity
sudo apt-get -y install ffmpeg
sudo apt-get -y install obs-studio
sudo apt-get -y install pikopixel.app
sudo apt-get -y install digikam
sudo apt-get -y install kdenlive
sudo apt-get -y install xournalpp
sudo apt-get -y install deluge
sudo apt-get -y install playonlinux 

# install Joplin
wget -O - https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bash

# install MiniGalaxy
sudo apt-get -y install minigalaxy
# create a login shortcut to use a fix that prevents the login window content from displaying, not needed when logged in, but keep around if you get logged out automatically or something
cat >> minigalaxy-login.sh << 'END'
WEBKIT_DISABLE_COMPOSITING_MODE=1 minigalaxy
END
# create another shortcut on the Desktop
cat >> ~/Desktop/minigalaxy-login.sh << 'END'
WEBKIT_DISABLE_COMPOSITING_MODE=1 minigalaxy
END
# make both shortcuts executable
sudo chmod +x minigalaxy-login.sh
sudo chmod +x ~/Desktop/minigalaxy-login.sh
# (run manually from File Manager, or from terminal with ./minigalaxy-login.sh)


# install Lutris
# https://www.devdungeon.com/content/install-lutris-gaming-debian
sudo apt-get -y install libvulkan1 libvulkan1:i386
echo "deb http://download.opensuse.org/repositories/home:/strycore/Debian_12/ ./" | sudo tee /etc/apt/sources.list.d/lutris.list
wget -q https://download.opensuse.org/repositories/home:/strycore/Debian_12/Release.key -O- | sudo apt-key add -
sudo apt update
sudo apt-get -y install lutris


# Heroic Games Launcher
# https://github.com/Heroic-Games-Launcher/HeroicGamesLauncher
wget https://github.com/Heroic-Games-Launcher/HeroicGamesLauncher/releases/download/v2.9.2/heroic_2.9.2_amd64.deb
sudo dpkg -i heroic_*_amd64.deb
rm -rf heroic_*_amd64.deb 


# VMWare Workstation Player 17
sudo apt-get -y install build-essential gcc perl bzip2 dkms make
sudo apt-get -y install linux-headers-$(uname -r)
sudo apt update && sudo apt upgrade -y
wget https://download3.vmware.com/software/WKST-PLAYER-1702/VMware-Player-Full-17.0.2-21581411.x86_64.bundle
chmod +x VMware-Player-Full-*.x86_64.bundle
sudo ./VMware-Player-Full-*.x86_64.bundle
git clone https://github.com/mkubecek/vmware-host-modules.git
cd vmware-host-modules
git checkout workstation-17.0.2
make
sudo make install
sudo /etc/init.d/vmware start
cd ~
rm -rf VMware-Player-Full-*.x86_64.bundle
rm -rf vmware-host-modules

# Fix vmware tools
#git clone https://github.com/rasa/vmware-tools-patches.git
#cd vmware-tools-patches
#sudo ./patched-open-vm-tools.sh
#cd ~
#sudo rm -rf vmware-tools-patches
# mount shared volumes temporarily
#sudo vmhgfs-fuse .host:/ /mnt/hgfs/ -o allow_other -o uid=1000
# If you want them mounted on startup, update /etc/fstab with the following:
# Use shared folders between VMWare guest and host
#.host:/    /mnt/hgfs/    fuse.vmhgfs-fuse    defaults,allow_other,uid=1000     0    0


# enable RPM package installation
sudo apt-get -y install alien
#alien --version
# after alien is installed you can install downloaded rpms by first converting the .rpm into a .deb:
#     sudo alien -d package-name.rpm
# then install the .deb with dpkg:
#     sudo dpkg -i package-name.deb
# if something goes wrong, try:
#     sudo apt --fix-broken install
# to check the installed package:
#     dpkg -l | grep package-name

# enable snaps and snap store - TAKES A REALLY LONG TIME
sudo apt-get -y install snapd
sudo snap install snap-store

sudo apt update
sudo apt upgrade -y
sudo apt clean
sudo reboot now
