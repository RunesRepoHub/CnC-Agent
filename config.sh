#!/bin/bash

##### Styles ######
Black='\e[0;30m'
DarkGray='\e[1;30m'
Red='\e[0;31m'
LightRed='\e[1;31m'
Green='\e[0;32m'
LightGreen='\e[1;32m'
BrownOrange='\e[0;33m'
Yellow='\e[1;33m'
Blue='\e[0;34m'
LightBlue='\e[1;34m'
Purple='\e[0;35m'
LightPurple='\e[1;35m'
Cyan='\e[0;36m'
LightCyan='\e[1;36m'
LightGray='\e[0;37m'
White='\e[1;37m'
NC='\e[0m'  # Reset to default
###################

###### WARNING ######
# This needs to be  #
# changed when push #
# to Production     #
#####################
# Version tag
Version="curl https://raw.githubusercontent.com/RunesRepoHub/CnC-WebGUI/Production/CnC-WebGUI/.env | sed 's/.\{8\}//'"
#####################

# Global Variables
dbip="/root/CnC-Agent/.databaseip"
ssh_password_path="/root/CnC-Agent/.sshpassword"
serverinstallcon="/root/CnC-WebGUI/.serverinstallcon"
clientinstallcon="/root/CnC-Agent/.clientinstallcon"

# Getting-started.sh
CnC_Image_Builder="/root/CnC-WebGUI/Functions/CnC-Image-Builder.sh"
Install_Agent="/root/CnC-Agent/Install-Agent.sh"

# Cronjob.sh 
crontxt="/root/CnC-Agent/cron.txt"

# Debian-Installer.sh 
pack_cron="/root/CnC-Agent/Debian-Scripts/Packages.sh"
over_cron="/root/CnC-Agent/Debian-Scripts/Overview.sh"
cron_cron="/root/CnC-Agent/Debian-Scripts/Cronjob.sh"

# Crontab-Installer.sh 
pack_cron_CI="/root/CnC-Agent/Crontab-Installer/Packages.sh"
over_cron_CI="/root/CnC-Agent/Crontab-Installer/Overview.sh"
cron_cron_CI="/root/CnC-Agent/Crontab-Installer/Cronjob.sh"
ssh_CI="/root/CnC-Agent/Crontab-Installer/SSH-Access.sh"


# Install-Agent.sh
deb_ins="/root/CnC-Agent/Debian-Installer.sh"

###### WARNING ######
# This needs to be  #
# changed when push #
# to Production     #
#####################
# Check-OS.sh
deb_url_ins="https://raw.githubusercontent.com/RunesRepoHub/CnC-WebGUI/Production/Functions/Run-Install-Debian.sh"
#####################


# CnC-Image-Builder.sh
ver_path="/root/CnC-WebGUI/CnC-WebGUI/.env"
web_path="/root/CnC-WebGUI/CnC-WebGUI/Nginx-Docker"
pg_path="/root/CnC-WebGUI/CnC-WebGUI/Postgress-Docker"
apt_path="/root/CnC-WebGUI/CnC-WebGUI/Nodejs-Docker"
compose="/root/CnC-WebGUI/CnC-WebGUI/docker-compose.yaml"

# Run-Install-Debian.sh
get_start="/root/CnC-WebGUI/Functions/Getting-started.sh"

# Agent install repo url
repo_url_ins="https://github.com/RunesRepoHub/CnC-Agent.git"

###### WARNING ######
# This needs to be  #
# changed when push #
# to Production     #
#####################
get_config_url="https://raw.githubusercontent.com/RunesRepoHub/CnC-WebGUI/Production/config.sh"
#####################