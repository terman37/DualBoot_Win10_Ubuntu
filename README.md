# My Dual boot win10 ubuntu 19.10

Notes on how to setup proper dual boot Win/Linux

on my Asus Zenbook UX534FT

( ! sound not working for now )

#### Prepare Windows:

- Disable bitlocker

- Shrink partition to make some space available ( > 20Go) - unformated

- Download ubuntu iso from https://ubuntu.com/download/desktop

- Create bootable usb disk using balenaEtcher

- Disable Fast Startup

  power options / Change settings that are currently unavailable / uncheck FastStartup

#### Modify BIOS (UEFI) settings:

- disable fastboot
- disable secure boot

#### Boot from Usb key:

- Select install ubuntu
- follow setup:
  - select language (English)
  - select keyboard layout (French - French (AZERY)) - check it's ok.
  - select normal installation - use nvidia drivers...
  - select install along Windows (it will detect and install it on empty partition created earlier)
  - define user / password / laptop name...
  - continue...
- it will reboot (remove usb stick)

#### Boot in Ubuntu

- Settings Setup:

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

- automount **windows partition**

  - create a folder ( ex: in /home/user/Windows )
  - find windows partition UUID:

  ```bash
  ls -l /dev/disk/by-label/
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

- Update

  ```bash
  sudo apt update
  sudo apt upgrade
  ```
  
- Hide icon of mounted drives from the dock

  - install **dconf editor**
    - from store
  - launch it and go to 
    - org / gnome / shell / extensions / dash-to-dock
  - turn off **show-mounts** option

#### Install Softwares:

- Remove unused softwares (ex: Games) to cleanup a bit

- Customize boot screen:

  - install **Grub Customizer**
  - modify order for booting (ex: windows first ...)
  - select image etc...

- Install **Git**

  ```bash
  sudo apt install git
  ```

- install **Github desktop**

  - download latest **deb** release from https://github.com/shiftkey/desktop/releases
  - install it

  ```bash
  sudo apt install ./GithubDesktop*.deb
  ```

  - Launch and configure

- install **MiniConda**

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

- install **Chrome**

  - download and install

    ```bash
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    ```
    ```bash
    sudo apt install ./google-chrome*.deb
    ```

- install **Typora**

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

- install **Sublime**

  - from store

- install **PyCharm CE**

  - from store

- install **MS Teams**:

  - download latest **deb** release from https://teams.microsoft.com/downloads#allDevicesSection

  - install it

    ```bash
    sudo apt install ./teams*.deb
    ```

  - Launch and configure