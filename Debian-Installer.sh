#!/bin/bash

# Define the paths of the scripts you want to remove from the crontab
pack_cron="/root/CnC-Agent/Debian-Scripts/Packages.sh"
over_cron="/root/CnC-Agent/Debian-Scripts/Overview.sh"
cron_cron="/root/CnC-Agent/Debian-Scripts/Cronjob.sh"

# Source the configuration script
source ~/CnC-Agent/config.sh

# Add a sleep to allow source check
sleep 5

me=$(basename "$0")

## Get database IP address
echo -e "${Green}Input Database IP${NC}"
read -p "Database IP: " databaseip

## Save database IP address
touch "$dbip"
echo "$databaseip" > "$dbip"

#!/bin/bash

# Paths to the scripts
pack_cron="/root/CnC-Agent/Debian-Scripts/Packages.sh"
over_cron="/root/CnC-Agent/Debian-Scripts/Overview.sh"
cron_cron="/root/CnC-Agent/Debian-Scripts/Cronjob.sh"

# Function to check if a cron job exists in /etc/crontab
cron_job_exists() {
    local script_path="$1"
    local cron_command="5 * * * * root bash $script_path"
    
    # Use `grep` to check if the cron command already exists in /etc/crontab
    grep -qF "$cron_command" /etc/crontab
}

# Function to add a cron job to /etc/crontab
add_cron_job() {
    local script_path="$1"
    local cron_command="5 * * * * root bash $script_path"
    
    # Append the cron job to /etc/crontab
    echo "$cron_command" | sudo tee -a /etc/crontab
    echo "Added cron job for $script_path"
}

# Add cron jobs if they do not exist in /etc/crontab
if ! cron_job_exists "$pack_cron"; then
    add_cron_job "$pack_cron"
fi

if ! cron_job_exists "$over_cron"; then
    add_cron_job "$over_cron"
fi

if ! cron_job_exists "$cron_cron"; then
    add_cron_job "$cron_cron"
fi


#!/bin/bash

# Paths to the scripts
pack_cron="/root/CnC-Agent/Debian-Scripts/Packages.sh"
over_cron="/root/CnC-Agent/Debian-Scripts/Overview.sh"
cron_cron="/root/CnC-Agent/Debian-Scripts/Cronjob.sh"

# Function to check if a cron job exists in /etc/crontab
cron_job_exists() {
    local script_path="$1"
    local cron_command="5 * * * * root bash $script_path"
    
    # Use `crontab -l` to check if the cron command already exists
    crontab -l | grep -qF "$cron_command"
}

# Function to add a cron job to /etc/crontab
add_cron_job() {
    local script_path="$1"
    local cron_command="5 * * * * root bash $script_path"
    
    # Add the cron job to /etc/crontab
    (crontab -l 2>/dev/null; echo "$cron_command") | crontab -
    echo "Added cron job for $script_path"
}

# Add cron jobs if they do not exist
if ! cron_job_exists "$pack_cron"; then
    add_cron_job "$pack_cron"
fi

if ! cron_job_exists "$over_cron"; then
    add_cron_job "$over_cron"
fi

if ! cron_job_exists "$cron_cron"; then
    add_cron_job "$cron_cron"
fi


## Make a file to check if installation was successful
touch "$clientinstallcon"
echo "yes" > "$clientinstallcon"