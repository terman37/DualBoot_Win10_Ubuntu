# My Dual boot win10 ubuntu 19.10

Notes on how to setup proper dual boot Win/Linux

on my Asus Zenbook UX534FT

( ! sound not working for now )

#### Prepare Windows:

- disable bitlocker
- shrink partition to make some space available ( > 20Go) - unformated
- download ubuntu iso, create bootable usb disk using balenaEtcher

#### Modify BIOS (UEFI) settings:

- disable fastboot
- disable secure boot

#### Boot from Usb key:

- select install ubuntu
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

  - disable screenpad display

    - settings / devices...

  - set ubuntu to use LocalTime to avoid time difference in windows when rebooting:

    ```bash
    timedatectl set-local-rtc 1 --adjust-system-clock
    ```

  - check graphic card used
    - settings / details 

- automount windows partition

  - create a folder ( ex: in /home/user/Windows )
  - find windows partition UUID:

  ```bash
  ls -l /dev/disk/by-uuid/
  ```

  - edit fstab

  ```bash
  sudo gedit /etc/fstab
  ```

  - add line in fstab (it will be mounted after reboot)

    ```
    UUID=<uuid found before> /home/user/Windows ntfs-3g defaults 0 0
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

- Customize boot screen:

  - install Grub Customizer
  - modify order for booting (ex: windows first ...)
  - select image etc...

- Install git

  ```bash
  sudo apt install git
  ```

- install Github desktop

  - download latest **deb** release from https://github.com/shiftkey/desktop/releases
  - install it

  ```bash
  sudo apt install ./GithubDesktop*.deb
  ```

  - Launch and configure

- install MiniConda

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

- install Chromium
- install Sublime
- install PyCharm

- install MS Teams:

  - download latest **deb** release from https://teams.microsoft.com/downloads#allDevicesSection

  - install it

    ```bash
    sudo apt install ./teams*.deb
    ```

  - Launch and configure