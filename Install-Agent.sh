# Source the configuration script
source ~/CnC-WebGUI/config.sh

if [ -f /etc/os-release ]; then
    # freedesktop.org and systemd
    . /etc/os-release
    OS=$NAME
    VER=$VERSION_ID
elif type lsb_release >/dev/null 2>&1; then
    # linuxbase.org
    OS=$(lsb_release -si)
    VER=$(lsb_release -sr)
elif [ -f /etc/lsb-release ]; then
    # For some versions of Debian/Ubuntu without lsb_release command
    . /etc/lsb-release
    OS=$DISTRIB_ID
    VER=$DISTRIB_RELEASE
elif [ -f /etc/debian_version ]; then
    # Older Debian/Ubuntu/etc.
    OS=Debian
    VER=$(cat /etc/debian_version)
elif [ -f /etc/SuSe-release ]; then
    # Older SuSE/etc.
    ...
elif [ -f /etc/redhat-release ]; then
    # Older Red Hat, CentOS, etc.
    ...
else
    # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
    OS=$(uname -s)
    VER=$(uname -r)
fi

user=$(whoami)

## Check if OS is Debian 10 
if [[ $OS == "Debian GNU/Linux" && $VER == "10" ]]; then
    
    ## Run Debian Installer
    bash "$deb_ins"

## Check if OS is Debian 10     
elif [[ $OS == "Debian GNU/Linux" && $VER == "11" ]]; then
    
    ## Run Debian Installer
    bash "$deb_ins"

## Check if OS is Ubuntu 22.04 and root user
elif [[ $OS == "Ubuntu" && $VER == "22.04" && $user == "root" ]]; then
    
    ## Run Debian Installer
    bash "$deb_ins"

else
echo "Unsupported OS"
fi