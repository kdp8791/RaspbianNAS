#! /bin/bash

# Install NTFS-3G
echo -e "---------------------------------\nINSTALLING NTFS-3G...\n---------------------------------\n"
sudo apt-get install ntfs-3g -y

# Print Disk Drives Available
echo -e "\n-------------------------------\nPRINTING DISK DRIVES AVAILABLE...\n---------------------------------\n"
sudo fdisk -l

# Prompt user for disk drive locations
read -p "Disk Drive 1 Device Boot (ex. /dev/sda1): " dev1
read -p "Disk Drive 2 Device Boot (ex. /dev/sdb1): " dev2

# Create Directories for HDD mounting
echo -e "---------------------------------\nCREATING DIRECTORIES...\n---------------------------------\n"
sudo mkdir /media/USBHDD1
sudo mkdir /media/USBHDD2

# Mount drives
echo -e "---------------------------------\nMOUNTING HARD DRIVES FOR NAS\n---------------------------------\n"
sudo mount -t auto $dev1 /media/USBHDD1
sudo mount -t auto $dev2 /media/USBHDD2

# Install SAMBA
echo -e "---------------------------------\nINSTALLING SAMBA...\n---------------------------------\n"
sudo apt-get install samba samba-common-bin -y

# Fetch Pre-built SAMBA Config from repo
echo -e "---------------------------------\nPULLING SAMBA CONFIG FROM REPO...\n---------------------------------\n"
sudo curl -o /etc/samba/smb.conf $URL

# Restart SAMBA
echo -e "---------------------------------\nRESTARTING SAMBA...\n---------------------------------\n"
sudo /etc/init.d/samba restart

# Prompt user for new SAMBA user creation
read -p "Username for NAS (this will be your login username): " user

# Add user
echo -e "---------------------------------\nADDING USER...\n---------------------------------\n"
sudo useradd $user -m -G users

# Create password
echo -e "---------------------------------\nCREATE PASSWORD FOR ${user}\n---------------------------------\n"
sudo passwd $user

# Add user to SAMBA
echo -e "---------------------------------\nADDING ${user} TO SAMBA, ENTER PASSWORD AGAIN...\n---------------------------------\n"
sudo smbpasswd -a $user

# Configuring auto mount on restart
echo -e "---------------------------------\nCONFIGURING AUTOMOUNT...\n---------------------------------\n"
sudo echo "${dev1} /media/USBHDD1 auto noatime 0 0" > /etc/fstab
sudo echo "${dev2} /media/USBHDD2 auto naotime 0 0" > /etc/fstab

# NAS SETUP COMPLETE
echo -e "---------------------------------\nSETUP COMPLETE!\n---------------------------------\n"



