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
        echo
        echo
        git clone --branch Dev https://github.com/RunesRepoHub/CnC-Agent.git;
        ## Runs the installation script
        wget -O ~/CnC-Agent/config.sh "$get_config_url" > /dev/null 2>&1;
        bash ~/CnC-Agent/Install-Agent.sh;
    else
        bash ~/CnC-Agent/Install-Agent.sh;
    fi
else 
    ## If the files has not been download before
    echo -e "${Green}$FILE does not exist.${NC}"
    ## Clones new files
    echo
    echo
    git clone --branch Dev https://github.com/RunesRepoHub/CnC-Agent.git;
    ## Runs the installation script
    bash ~/CnC-Agent/Install-Agent.sh;
fi 
