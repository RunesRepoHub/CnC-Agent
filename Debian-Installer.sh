#!/bin/bash

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

# Collect SSH password (you may want to handle this securely)
read -s -p "Enter password: " ssh_password

## Save SSH Password
touch "$ssh_password_path"
echo "$ssh_password" > "$ssh_password_path"

# Function to check if a cron job exists in /etc/crontab
cron_job_exists() {
    local script_path="$1"
    local cron_command="5,10,15,20,25,30,35,45,50,55,0 * * * * root bash $script_path"
    
    # Use `grep` to check if the cron command already exists in /etc/crontab
    grep -qF "$cron_command" /etc/crontab
}

# Function to add a cron job to /etc/crontab
add_cron_job() {
    local script_path="$1"
    local cron_command="5,10,15,20,25,30,35,45,50,55,0 * * * * root bash $script_path"
    
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



# Function to check if a cron job exists in /etc/crontab
cron_job_exists() {
    local script_path="$1"
    local cron_command="5,10,15,20,25,30,35,45,50,55,0 * * * * root bash $script_path"
    
    # Use `crontab -l` to check if the cron command already exists
    crontab -l | grep -qF "$cron_command"
}

# Function to add a cron job to /etc/crontab
add_cron_job() {
    local script_path="$1"
    local cron_command="5,10,15,20,25,30,35,45,50,55,0 * * * * root bash $script_path"
    
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

bash "$ssh_CI"

## Make a file to check if installation was successful
touch "$clientinstallcon"
echo "yes" > "$clientinstallcon"