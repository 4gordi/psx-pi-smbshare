#!/bin/bash

#If a USB drive is present, do not initialize the samba share
USBDisk_Present=`sudo fdisk -l | grep /dev/sd`
if [ -n "${USBDisk_Present}" ]
then
    echo "exited to due to presence of USB storage"
    exit
fi

sudo cat <<'EOF' | sudo tee /etc/samba/smb.conf
[global]
log level = 1
workgroup = WORKGROUP
server string = PS2 Samba Server
server role = standalone server
log file = /dev/stdout
max log size = 0
load printers = no
printing = bsd
printcap name = /etc/printcap
printcap cache time = 0
disable spoolss = yes
pam password change = yes
map to guest = bad user
usershare allow guests = yes
create mask = 0664
force create mode = 0664
directory mask = 0775
force directory mode = 0775
force user =
force group = users
server min protocol = NT1
server signing = disabled
smb encrypt = disabled
socket options = TCP_NODELAY TCP_KEEPIDLE=20 IPTOS_LOWDELAY SO_KEEPALIVE
keepalive = 0
write cache size = 0
getwd cache = yes
large readwrite = yes
aio read size = 0
aio write size = 0
strict locking = no
strict sync = no
strict allocate = no
read raw = no
write raw = no
follow symlinks = yes
[ps2smb]
comment = PlayStation 2
path = /share
browsable = no
guest ok = yes
public = no
writable = yes
available = yes
read only = no
veto files = /._*/.apdisk/.AppleDouble/.DS_Store/.TemporaryItems/.Trashes/desktop.ini/ehthumbs.db/Network Trash Folder/Temporary Items/Thumbs.db/
delete veto files = yes
EOF

#if you wish to create a samba user with password you can use the following:
#sudo smbpasswd -a pi
sudo /etc/init.d/smbd restart
