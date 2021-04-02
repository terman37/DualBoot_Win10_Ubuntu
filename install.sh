#!/bin/bash

# Settings
separator="###########################################################################"

# Setup
echo $separator
echo "1.SETUP"
echo $separator

####################################################
# Mount Windows Partition to ~/Windows
echo -e "\tClock"
timedatectl set-local-rtc 1 --adjust-system-clock
echo -e "\tMount Windows Partition"

####################################################
# Mount Windows Partition to ~/Windows
function choosedisk {
    n=0
	for disk in "${array[@]}"
        do
            printf "$n: $disk\n"
            n=$((n+1))
        done
    read choice
}

# Create array of disks to choose from.
lsblk -l -n -o NAME,TYPE,SIZE,FSTYPE,PARTLABEL,UUID | grep 'part' > disks
n=0
while read line; do
    array[$n]=$line
    n=$((n+1))
done < disks

rm disks

# Ask user to choose disk.
echo "Choose Windows partition to be mounted to ~/Windows:"
choosedisk
choice_ok=0
re='^[0-9]+$' #Make sure $choice is a number
while [ $choice_ok -eq 0 ] ; do
    if ! [[ $choice =~ $re ]] || [ $choice -ge $n ] ; then
        echo "Error: Please enter the NUMBER of your choice."
        choosedisk
    else
    	choice_ok=1
    fi
done

# add mount to fstab
mkdir $HOME/Windows
fstab_add=$(echo "UUID=$(echo ${array[$choice]} | rev | cut -d " " -f1 | rev) $HOME/Windows ntfs-3g defaults 0 0")
sudo su -c "echo $fstab_add >> /etc/fstab"
sudo mount -a

# disable icon in dock
gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts false

echo $separator
echo "2.UPDATE & DEPENDENCIES"
####################################################
# update
sudo apt update -y
sudo apt dist-upgrade -y

# dependencies
sudo apt install apt-transport-https ca-certificates curl gnupg lsb-release software-properties-common

echo $separator
echo "3.REPOSITORIES"
####################################################
# Add repositories

# KeepassXC
sudo add-apt-repository -y ppa:phoerious/keepassxc

# Typora
wget -qO - https://typora.io/linux/public-key.asc | sudo apt-key add -
sudo add-apt-repository -y 'deb https://typora.io/linux ./'

# Sublime Text
curl -fsSL https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
sudo add-apt-repository -y "deb https://download.sublimetext.com/ apt/stable/"

# VsCode
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

# Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Dbeaver
sudo add-apt-repository -y ppa:serge-rider/dbeaver-ce

####################################################
# update
sudo apt update

echo $separator
echo "4.INSTALL"
####################################################
# Install

cd $HOME/Downloads

# KeyPAssXC
echo -e "\t KeyPassXC"
sudo apt install -y keepassxc

# Grub Customizer
echo -e "\t Grub Customizer"
sudo apt install -y grub-customizer

# Git
echo -e "\t Git"
sudo apt install -y git

# Typora
echo -e "\t Typora"
sudo apt install -y typora

# Sublime Text
echo -e "\t Sublime"
sudo apt install -y sublime-text

# VsCode
echo -e "\t VsCode"
sudo apt install -y code

# Docker
echo -e "\t Docker"
sudo apt install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker ${USER}

# Docker Compose
echo -e "\t Docker Compose"
version=1.28.6
sudo curl -L "https://github.com/docker/compose/releases/download/$version/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Dbeaver CE
echo -e "\t Dbeaver"
sudo apt install -y dbeaver-ce

# Gimp
echo -e "\t Gimp"
sudo apt install -y gimp

# Python pip
sudo apt install -y python3-pip
sudo pip3 install pip setuptools wheel --upgrade

# Evolution Mail
sudo apt install -y evolution

############

# Chrome
echo -e "\t CHROME"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install -y ./google-chrome*.deb

# GitHub Desktop
echo $separator
echo -e "\t Github Desktop"
echo "Download latest version from https://github.com/shiftkey/desktop/releases"
read -p "When Download OK. Press [ENTER]" -s
sudo apt install -y ./GitHubDesktop*.deb

# DisplayLink driver
echo $separator
echo -e "\DisplayLink Driver"
echo "Download latest version from https://www.displaylink.com/downloads/ubuntu"
read -p "When Download OK. Press [ENTER]" -s
unzip DisplayLink*.zip
chmod +x displaylink*.run
sudo ./displaylink*.run

####################################################
# Clean

sudo apt autoremove -y
rm google-chrome*.deb
rm GitHubDesktop*.deb
rm DisplayLink*.zip
rm displaylink*.run


####################################################
# Set Taskbar favorites
gsettings set org.gnome.shell favorite-apps "['google-chrome.desktop', 'org.gnome.Evolution.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'github-desktop.desktop', 'code.desktop', 'dbeaver.desktop']"