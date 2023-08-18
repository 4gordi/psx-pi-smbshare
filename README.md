# psx-pi-smbshare
psx-pi-smbshare began with the intent of allowing SMB sharing to Multiman and Open Playstation Loader from a Raspberry Pi.  It has evolved into a Pi-based swiss army knife for enhancing classic game consoles.  

You can see it in action in this video from [@versatileninja](https://github.com/versatileninja) which walks through the setup process and demonstrates how to use it:

[![Play PS2 Games Over SMB Using Raspberry Pi 3b+ and psx-pi-smbshare (2019)](https://img.youtube.com/vi/Ilx5NYoUkNA/0.jpg)](https://www.youtube.com/watch?v=Ilx5NYoUkNA)

## Upgrading an existing install
The following commands can be used to upgrade an existing psx-pi-smbshare device.  These instructions can also be used to convert an unsupported device into a psx-pi-smbshare (for example [Raspberry Pi4](https://github.com/toolboc/psx-pi-smbshare/issues/10) and potentially other devices running a debian based OS with an accessible ethernet port).
```
cd ~
wget -O setup.sh https://raw.githubusercontent.com/4gordi/psx-pi-smbshare/master/setup.sh
chmod 755 setup.sh
./setup.sh
```

## How it works
psx-pi-smbshare is a preconfigured Raspbian based image for Raspberry Pi 1, 2, 3 and [4](https://www.youtube.com/watch?v=8qaJcbSye-E).  It runs a [Samba](https://en.wikipedia.org/wiki/Samba_(software)) share, a pi-compatible build of [ps3netsrv](https://github.com/dirkvdb/ps3netsrv--), and reconfigures the ethernet port to act as a router.  This gives low-latency, direct access to the Samba service through an ethernet cable connection between a PS2/PS3 and Raspberry Pi.  This configuration is achieved by running [setup.sh](/setup.sh).  A pre-supplied [image](https://github.com/toolboc/psx-pi-smbshare/releases/) can be applied directly to a Micro-SD card using something like [etcher.io](https://etcher.io/).  The image allows you to use the full available space on the SD card after the OS is first booted.

An [XLink Kai](http://www.teamxlink.co.uk/) client is also included and accessible on the device at http://smbshare:34522/.  This allows for multi-player gaming over extended LAN.  The service is possible to use on a variety of devices including PS2, PS3, PS4, Xbox, Xbox 360, Xbox One, Gamecube, Switch, Wii, Wii U (and PSP).  Just connect an ethernet cable to your game console and access the XLink Kai Service over Wi-Fi with a smart phone, tablet, or computer.

![image](https://user-images.githubusercontent.com/2018336/102703167-08004c00-4231-11eb-931d-3046ccd117ac.png)

## What you can do with it
psx-pi-smbshare works out of the box on PS3 with [MultiMAN](http://www.psx-place.com/threads/update2-multiman-v-04-81-00-01-02-base-update-stealth-for-cex-dex-updates-by-deank.12145/).  This functionality allows you to stream and backup up various games and media to the Samba share service running on the Raspberry Pi.

psx-pi-smbshare also works out of the box on PS2 with [Open Playstation Loader](https://github.com/ifcaro/Open-PS2-Loader) and supports streaming of PS2 backups located on the Samba share service. It can also work with [POPStarter for SMB](https://bitbucket.org/ShaolinAssassin/popstarter-documentation-stuff/wiki/smb-mode) to allow streaming of PS1 games from Open Playstation Loader.

psx-pi-smbshare supports an ability to route traffic from the ethernet port through a wireless network connection to the outside world.  With this configuration, the XLink Kai Service can be used on pretty much any device with an ethernet port.  This includes Xbox, Xbox 360, PS2, PS3, and Gamecube.  There is also support for Ad-Hoc multiplayer on PSP using XLink Kai.  

# Quickstart

*Prerequisites*
* Raspberry Pi 1, 2, or 3
* Micro-SD Card (8GB+ suggested)

A detailed [video guide](https://www.youtube.com/watch?time_continue=1&v=Ilx5NYoUkNA) is provided by Project Phoenix Media which walks through the processes described below.

## Flash the image
Download the latest [psx-pi-smbshare release image](https://github.com/toolboc/psx-pi-smbshare/releases/) and burn it to a Micro-SD card with [etcher.io](http://etcher.io)

## Configuring Wireless Network
If you wish to configure the wireless network on a Raspberry Pi 2 or 3, you need to add a file to **/boot** on the Micro-SD card.  

Create a file on **/boot** named **wpa_supplicant.conf** and supply the following (change country to a [valid 2 letter code](https://en.wikipedia.org/wiki/ISO_3166-1)):

    ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
    update_config=1
    country=US
    
    network={
            ssid="<SSID>"
            psk="<PASSWORD>"
    }

When the pi is next booted, it will attempt to connect to the wireless network in this configuration.  You are then able to access the raspberry pi on the network and allow for outbound connections from a PS2/PS3 over the wireless network.  
The raspberry pi is configured to have a hostname `smbshare` with a user `pi` and a password of `raspberry`.  

## Disable DHCP server on Raspberry Pi

The default behavior of psx-pi-smbshare is to enable a console-to-pi connection by means of the high speed ethernet port available on many video game consoles. This connection is used to provide a direct access from the console to the services on the pi (WiFi, XLinkKai, SMB, ps3netsrv etc), and by default, a DHCP server runs on the ethernet interface (eth0) to facilitate this.  The following steps will describe how to disable this mechanism and is not recommended for typical users.  Please be aware that disabling the DHCP server will produce a side-effect of [no longer being able to directly connect your video game console to the pi via the ethernet interface](https://github.com/toolboc/psx-pi-smbshare/issues/22#issuecomment-667469343).    

In some use cases, the user may wish to connect the Raspberry Pi via ethernet to an external router (for example: [to have psx-pi-smbshare act as an XLinkKai server for primarily PSP games](https://github.com/toolboc/psx-pi-smbshare/issues/21)).  To disable the DHCP server that would usually run automatically on this interface, [ssh into your device](https://www.raspberrypi.org/documentation/remote-access/ssh/) and execute the following command to modify the startup scripts that run at boot time:
```
crontab -e
```
Next, find and comment the line containing `@reboot sudo bash /home/pi/wifi-to-eth-route.sh` by adding a '#' as shown below:
```
#@reboot sudo bash /home/pi/wifi-to-eth-route.sh
```

## Accessing the SMB Share
With a wireless network configured, you should be able to access the SMB share by visiting `\\SMBSHARE\share` on windows or `smb://smbshare/share` on Mac / Linux.

![Accessing SMB](/Assets/smbshare.PNG)

The share is preconfigured with a folder structure to accomodate ps3netsrv and Open Playstation Loader expected file paths.

## Accessing USB drive(s) on the SMB Share
Plug and play auto-sharing of USB storage devices over SMB is supported:

* USB Drives are automounted to the /media/<Partition> directory

* When a USB drive is plugged in, the USB Drive becomes available on the SMB Share @ `\\SMBSHARE\share` 
    
* When a USB drive is removed, the device falls back to sharing the Micro-SD card @ `\\SMBSHARE\share` 

* Note that some USB drives (particularly larger enclosure types) may require use of a powered USB Hub to supply adequate current to the device

## Configuring for use with Open Playstation Loader

*Prerequisites*
* Playstation 2 fat or slim running a [recent release of Open Playstation Loader](http://www.ps2-home.com/forum/viewtopic.php?p=29251#p29251) 

*Steps*
1. Connect the pi ethernet port into the ethernet port of the PS2 and power the pi using the PS2 usb or an external power supply 
2. Boot Open Playstation Loader and select "Settings" => "Network Config".  
Ensure that the following options are set:

        Ethernet Link Mode = Auto
        PS2 
            IP address type = Static
            IP address = 192.168.2.2
            Mask = 255.255.255.0
            Gateway = 192.168.2.1
            DNS Server = 8.8.8.8
        SMB Server
            Address Type = IP
            Address = 192.168.2.1
            Port = 445
            Share = share
            Password = <not set>

    ![PS2 OPL Settings](/Assets/PS2-OPL-settings.png)

Don't forget to select "Save Config" when you return to "Settings"

3. Reconnect or restart Open Playstation Loader
4. PS2 Games will be listed under "ETH Games".  To add PS2 games, copy valid .iso backups to `\\SMBSHARE\share\DVD` or `\\SMBSHARE\share\CD`

## Configuring for use with POPSLoader on Open Playstation Loader

*Prerequisites*
* Ensure that you have successfully followed the steps above for "Configuring for use with Open Playstation Loader"

*Steps*
1. Download the [ps2 network modules](https://bitbucket.org/ShaolinAssassin/popstarter-documentation-stuff/downloads/network_modules.7z) 
2. Extract the POPSTARTER folder 
3. Modify IPCONFIG.DAT to:
        
        192.168.2.2 255.255.255.0 192.168.2.1
4. Modify SMBCONFIG.DATA to:
        
        192.168.2.1 share
5. Copy the POPSTARTER folder to your memory card
6. Hop on the internet and look for a copy of a file named "POPS_IOX.PAK" with md5sum "a625d0b3036823cdbf04a3c0e1648901" and copy it to `\\SMBSHARE\share\POPS`.  This file is not included for "reasons".
7. PS1 backups must be converted to .VCD and run through a special renaming program in order to show up in OPL.

    To convert .bin + .cue backups, you can use the included "CUE2POP_2_3.EXE" located in `\\SMBSHARE\share\POPS\CUE2POPS v2.3`
    Copy your .VCD backups to `\\SMBSHARE\share\POPS` then run `\\SMBSHARE\share\POPS\OPLM\OPL_Manager.exe` to rename your files appropriately.
    
    Once converted and properly renamed, your games will show up under the "PS1 Games" section of OPL

    A detailed guide is available @ http://www.ps2-home.com/forum/viewtopic.php?f=64&t=5002

# Credits
Thx to the following:
* Jay-Jay for [OPL Daily Builds](https://github.com/Jay-Jay-OPL/OPL-Daily-Builds) 
* danielb for [OPLM](http://www.ps2-home.com/forum/viewtopic.php?f=64&t=189)
* arpitjindal97 for [wifi-to-eth-route.sh](https://github.com/arpitjindal97/raspbian-recipes/blob/master/wifi-to-eth-route.sh)
* Pul Gasari for [Testing streaming games from Raspberry Pi to PS2 using psx-pi-smbshare](https://www.youtube.com/watch?v=FJEdWW6YhJo&feature=youtu.be)
