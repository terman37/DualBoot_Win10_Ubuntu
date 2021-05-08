#!/bin/bash

# Settings
separator="###########################################################################"

# install

# evolution ews
# Pulse client
# zoom
# slack
# kubectl
# helm
# terraform

# typora
# sublimetext
# vscode
# docker
# dbeaver
# Chrome
# zsh
# ohmyzsh

# font
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hack.zip
unzip Hack.zip -d ./hack && rm Hack.zip
find ./hack -iname "*Windows*" -exec rm {} \; # suppression des fonts compatible Windows.
sudo mv hack /usr/share/fonts/
fc-cache -v


# add aliases / autocompletion / plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# dans zshrc ajouter
HIST_STAMPS="yyyy-mm-dd"

# Powerlevel10k
git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
ZSH_THEME="powerlevel10k/powerlevel10k"

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

# ZSH and oh-my-zsh and theme




sudo apt install -y zsh # fonts-powerline
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
sed -i 's/^ZSH_THEME=\".*\"/ZSH_THEME=\"agnoster\"/' .zshrc

# byobu
sudo apt install -y byobu
touch ~/.byobu/.tmux.conf
echo "set -g mouse on" >> ~/.byobu/.tmux.conf
echo "set -g default-shell /usr/bin/zsh" >> ~/.byobu/.tmux.conf
echo "set -g default-command /usr/bin/zsh" >> ~/.byobu/.tmux.conf


############

# Chrome
echo -e "\t CHROME"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install -y ./google-chrome*.deb

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
rm DisplayLink*.zip
rm displaylink*.run


####################################################
# Set Taskbar favorites
# gsettings set org.gnome.shell favorite-apps "['google-chrome.desktop', 'org.gnome.Evolution.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'github-desktop.desktop', 'code.desktop', 'dbeaver.desktop']"