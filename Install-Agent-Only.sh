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

# Install needed tools for installation script to work
echo -e "${Purple}Move to root directory${NC}"
cd
echo -e "${Yellow}Install sudo, Git, jq${NC}"
apt-get install sudo >/dev/null 2>&1
apt-get install git -y >/dev/null 2>&1
apt-get install jq -y >/dev/null 2>&1
echo -e "${Yellow}Install updates and Upgrade${NC}"
apt-get updates >/dev/null 2>&1
apt-get upgrade -y >/dev/null 2>&1

FILE=~/CnC-Agent
if [ -d "$FILE" ]; then
    ## Clear screen for better overview
    
    ## Inform the user if the file has already been downloaded
    echo -e "${Red}$FILE exists.${NC}"
    echo -e "${Red}Do you want to delete the old files and install a new version?${NC}"
    echo
    ## Ask the user for action input
    read -p "Are you sure? " -n 1 -r
    ## Move to a new line
    echo
    ## Check user input    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        ## Remove old files
        rm -rf ~/CnC-Agent
        ## Clones new files
        git clone --branch Production https://github.com/RunesRepoHub/CnC-Agent.git;
        ## Runs the installation script
        wget -O ~/CnC-Agent/config.sh https://raw.githubusercontent.com/RunesRepoHub/CnC-WebGUI/Dev/config.sh > /dev/null 2>&1;
        sleep 3
        bash ~/CnC-Agent/Install-Agent.sh;
    else
        bash ~/CnC-Agent/Install-Agent.sh;
    fi
else 
    ## If the files has not been download before
    echo -e "${Green}$FILE does not exist.${NC}"
    ## Clones new files
    git clone --branch Production https://github.com/RunesRepoHub/CnC-Agent.git;
    sleep 3
    ## Runs the installation script
    bash ~/CnC-Agent/Install-Agent.sh;
fi 

if [ -f ~/CnC-WebGUI/.serverinstallcon ] && [ -f ~/CnC-Agent/.clientinstallcon ]; then
    echo -e "${Green}Both Agent and Server was installed successful${NC}"
elif  [ -f ~/CnC-Agent/.clientinstallcon ]; then
    echo -e "${Green}The Agent was installed successful${NC}"
else
    echo -e "${Red}Installation has failed${NC}"
fi