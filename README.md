#minidlna-autoconfig
###Systemd services for minidlna

These services enable minidlna to be started as a normal user. A minidlna-autoconfig service is included in order to create configuration files and get minidlna working out-of-box.

##What does he do ?

There is 2 services in this package:
* minidlna@.service : start minidlna as a simple user
* minidlna-autoconfig@.service : create configurations files and directories for a normal user. The minidlna-autoconfig service uses 2 scripts : one that dump the original configuration file and modify it with default values and the other that checks if configuration files exist and create them if necessary.

##How to install ?

First of all, this script works only with systemd because it's using systemd services.

You must have, installed in your system:
* systemd
* minidlna

There is a makefile that enable to install it directly by making a "make install" as root. You can also use "make remove" in order to remove it.

If you use Arch Linux, you can find it in the AUR (search for minidlna-autoconfig)
