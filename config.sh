#!/bin/bash

# Version tag
Version="1.2"

# Global Variables
dbip="/root/CnC-WebGUI/CnC-Agent/.databaseip"

# Getting-started.sh
Install_Agent="/root/Install-Agent.sh"
Uninstall=""

# Cronjob.sh 
crontxt="/root/CnC-Agent/cron.txt"

# Debian-Installer.sh 
pack_cron="/root/CnC-Agent/Debian-Scripts/Packages.sh"
over_cron="/root/CnC-Agent/Debian-Scripts/Overview.sh"
cron_cron="/root/CnC-Agent/Debian-Scripts/Cronjob.sh"


# Install-Agent.sh
deb_ins="/root/CnC-Agent/Debian-Installer.sh"
