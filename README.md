# My Dual boot win10 ubuntu 20.04

Notes on how to setup proper dual boot Win/Linux

on my Asus Zenbook UX534FT

( ! sound not working for now - except in HDMI ) / fixed by script 2020-07-28

### Prepare Windows

- Disable bitlocker

- Shrink partition to make some space available ( > 50Go) - unformated

- Download ubuntu iso from https://ubuntu.com/download/desktop

- Create bootable usb disk using balenaEtcher

- Disable Fast Startup

  power options / Change settings that are currently unavailable / uncheck FastStartup

### Modify BIOS (UEFI) settings

- disable fastboot
- disable secure boot

### Boot from Usb key

- Select install ubuntu
- follow setup:
  - select language (English)
  - select keyboard layout (French - French (AZERY)) - check it's ok.
  - select normal installation - use nvidia drivers...
  - select install along Windows (it will detect and install it on empty partition created earlier)
  - define user / password / laptop name...
  - continue...
- it will reboot (remove usb stick)

### Boot in Ubuntu

#### Settings Setup:

- disable Screenpad display

  - settings / devices...

- set ubuntu to use LocalTime to avoid time difference in windows when rebooting:

  ```bash
  timedatectl set-local-rtc 1 --adjust-system-clock
  ```

- check graphic card used
  
  - settings / details 
  
  - and/or
  
    ```bash
    nvidia-smi
    ```

#### Automount Windows Partition

- create a folder ( ex: in /home/user/Windows )
- find windows partition UUID:

```bash
ls -l /dev/disk/by-partlabel/
ls -l /dev/disk/by-uuid/
```

- edit fstab

```bash
sudo gedit /etc/fstab
```

- add line in fstab (it will be mounted after reboot)

  ```
  UUID=<uuid found before> <path_to_folder_created> ntfs-3g defaults 0 0
  ```

- force mounting now:

  ```bash
  sudo mount -a
  ```

#### Update

```bash
sudo apt update
sudo apt upgrade
```

#### Hide icon of mounted drives from the dock

- install **dconf editor**
  - from store
- launch it and go to 
  - org / gnome / shell / extensions / dash-to-dock
- turn off **show-mounts** option

#### Fix sound issue

- create a file /etc/rc.local

  ```bash
  sudo nano /etc/rc.local
  ```

- copy script in file

  ```bash
  #!/bin/bash
  
  hda-verb /dev/snd/hwC0D0 0x20 0x500 0xf
  hda-verb /dev/snd/hwC0D0 0x20 0x477 0x74
  exit 0
  ```

- setup permissions / make it executable

  ```bash
  sudo chmod +x /etc/rc.local
  ```

### Install Softwares:

#### Remove unused softwares (ex: Games) to cleanup a bit

> #### install **Chrome** - No switch to firefox

- download and install

  ```bash
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  ```
  ```bash
  sudo apt install ./google-chrome*.deb
  ```

#### Install Keepass2:

- install

  ```
  sudo add-apt-repository ppa:jtaylor/keepass
  sudo apt update
  sudo apt install keepass2 mono-complete
  ```

- copy plugin KeepassRPC from https://github.com/kee-org/keepassrpc/releases/tag/v1.11.0

  ```
  sudo cp  KeePassRPC.plgx /usr/lib/keepass2/Plugins/KeePassRPC.plgx
  ```

- install firefox extension: Kee - Password Manager by [Luckyrat](https://addons.mozilla.org/en-US/firefox/user/5248570/)

#### Customize boot screen:

- install **Grub Customizer**
- modify order for booting (ex: windows first ...)
- select image etc...

#### Install **Git**

```bash
sudo apt install git
```

#### Install **Github desktop**

- download latest **deb** release from https://github.com/shiftkey/desktop/releases
- install it

```bash
sudo apt install ./GithubDesktop*.deb
```

- Launch and configure

> #### install **MiniConda** - Switch to python and venv

```bash
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
```

```bash
sh Miniconda3-latest-Linux-x86_64.sh
```

- install Jupyter notebook (in base env)

  ```bash
  conda install jupyter
  ```

- install kernels in select env

  ```bash
  conda install ipykernel
  ```

#### Install (update) python

- install specific verison (ex 3.7)

  - download from python Gzipped tarball https://www.python.org/downloads/source/ or 

    ```bash
    wget https://www.python.org/ftp/python/3.7.8/Python-3.7.8.tgz
    ```

  - uncompress

    ```bash
    sudo tar xzf Python-3.7.8.tgz
    ```

  - compile (make alt install to keep existing configsudo)

    ```bash
    cd /usr/src
    cd Python-3.7.8
    sudosudo ./configure --enable-optimizations
    sudo make altinstall
    ```

  - check

    ```bash
    python3.7 -V
    ```

  - check install path

    ```bash
    which python3
    which python3.7
    ```

- install pip / venv

  ```bash
  sudo apt install python3-pip
  sudo apt install python3-venv
  ```

- Use:

  - python3 for default python3 install
  - python3.7 for specific version
  - **avoid** python: for python 2.7
  - once in a virtual env: use python and pip

- Example

  - python 3 (default version)

    ```
    python3 -m venv venv/test3
    source venv/test3/bin/activate
    pip list
    ```

    returns: /usr/bin/python3

  - python 3 (default version)

    ```
    python3.7 -m venv venv/test37
    source venv/test37/bin/activate
    pip list
    ```

    returns: /usr/local/bin/python3.7

#### Install **Typora**

```bash
wget -qO - https://typora.io/linux/public-key.asc | sudo apt-key add -
```

```bash
sudo add-apt-repository 'deb https://typora.io/linux ./'
```

```bash
sudo apt update
```

```bash
sudo apt install typora
```

#### Install **Sublime**

- from store

> #### install **PyCharm CE** - Switch to VSCode

- from store

#### Install **VSCode**

- from store

> #### install **MS Teams**: - Not needed anymore

> - download latest **deb** release from     https://teams.microsoft.com/downloads#allDevicesSection

- install it

  ```bash
  sudo apt install ./teams*.deb
  ```

- Launch and configure

#### Install Docker

- docker

  - install

  ```bash
  sudo apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  sudo apt update
  sudo apt install docker-ce docker-ce-cli containerd.io
  ```

  - check

  ```bash
  sudo systemctl status docker
  ```

- post install / permissions as non root user

  ```bash
  sudo usermod -aG docker ${USER}
  ```

- docker compose (1.26.2) official doc https://docs.docker.com/compose/install/
  ```bash
  sudo curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  
  sudo chmod +x /usr/local/bin/docker-compose
  ```

#### Install DBeaver

- install from store



