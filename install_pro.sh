#!/bin/bash

# Settings
separator="###########################################################################"

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

# Kubernetes
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list

# Helm
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list

# Terraform
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

####################################################
# update
sudo apt update

echo $separator
echo "4.INSTALL - APT PACKAGES"
####################################################
# Install - Apt packages

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

# Evolution Mail
echo -e "\t Evolution Email with Exchange"
sudo apt install -y evolution-ews

# Kubernetes
echo -e "\t Kubectl"
sudo apt install -y kubectl

# Kubernetes namespace & cluster switcher
sudo apt install -y fzf
sudo curl https://raw.githubusercontent.com/blendle/kns/master/bin/kns -o /usr/local/bin/kns && sudo chmod +x $_
sudo curl https://raw.githubusercontent.com/blendle/kns/master/bin/ktx -o /usr/local/bin/ktx && sudo chmod +x $_

# Helm
echo -e "\t Helm"
sudo apt install -y helm

# Terraform
echo -e "\t Terraform"
sudo apt install -y terraform

####################################################
# ZSH and oh-my-zsh and theme
# Zsh
sudo apt install -y zsh
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# font
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip
unzip Meslo.zip -d ./meslo && rm Meslo.zip
find ./meslo -iname "*Windows*" -exec rm {} \; # suppression des fonts compatible Windows.
sudo mv meslo /usr/share/fonts/
fc-cache -v

# plugins + powerlevel10k
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k

# Zshrc

# modify .zshrc
sed -i 's/^ZSH_THEME=\".*\"/ZSH_THEME=\"powerlevel10k/powerlevel10k\"/' .zshrc
sed -i 's/^# HIST_STAMPS=\".*\"/HIST_STAMPS=\"yyyy-mm-dd\"/' .zshrc
sed -i 's/^plugins=(.*/plugins=(docker kubectl helm terraform zsh-completions zsh-syntax-highlighting git)/' .zshrc

# byobu
sudo apt install -y byobu
touch ~/.byobu/.tmux.conf
echo "set -g mouse on" >> ~/.byobu/.tmux.conf
echo "set -g default-shell /usr/bin/zsh" >> ~/.byobu/.tmux.conf
echo "set -g default-command /usr/bin/zsh" >> ~/.byobu/.tmux.conf

# Aliases & Completion
# Kubernetes
echo 'source <(kubectl completion zsh)' >>~/.zshrc
echo 'alias k=kubectl' >>~/.zshrc
echo 'complete -F __start_kubectl k' >>~/.zshrc

echo "alias watch='watch -d '" >> ~/.zshrc 

echo $separator
echo "5.INSTALL - Manual Download needed"
####################################################
# Install - Manual Download needed

############
# Chrome
echo -e "\t CHROME"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install -y ./google-chrome*.deb
rm google-chrome*.deb

# Zoom
echo $separator
echo -e "\Zoom"
echo "Download latest version from https://zoom.us/download?os=linux"
read -p "When Download OK. Press [ENTER]" -s
sudo apt install ./zoom_amd64.deb
rm zoom*.deb

# Slack
echo $separator
echo -e "\Slack"
echo "Download latest version from https://slack.com/intl/en-fr/downloads/linux"
read -p "When Download OK. Press [ENTER]" -s
sudo apt install ./slack*.deb
rm slack*.deb

# DisplayLink driver
echo $separator
echo -e "\DisplayLink Driver"
echo "Download latest version from https://www.displaylink.com/downloads/ubuntu"
read -p "When Download OK. Press [ENTER]" -s
unzip DisplayLink*.zip
rm DisplayLink*.zip
chmod +x displaylink*.run
sudo ./displaylink*.run
rm displaylink*.run

# Pulse Secure
echo $separator
echo -e "\Pulse Secure Client"
echo "Download latest version from https://software.uconn.edu/pulse-secure-client-download/"
read -p "When Download OK. Press [ENTER]" -s
sudo apt install ./Pulse*.deb
rm Pulse*.deb
sudo add-apt-repository 'deb http://archive.ubuntu.com/ubuntu bionic main universe'
sudo apt install -t bionic libwebkitgtk-1.0-0

echo $separator
echo "6.CLEANING"
####################################################
# Clean
sudo apt autoremove -y

####################################################
# Set Taskbar favorites
# gsettings set org.gnome.shell favorite-apps "['google-chrome.desktop', 'org.gnome.Evolution.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'github-desktop.desktop', 'code.desktop', 'dbeaver.desktop']"

# Tobe done manually

# setup evolution mail

# 