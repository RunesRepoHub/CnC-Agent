#!/bin/bash

# Source the configuration script
source ~/CnC-Agent/config.sh

# Add a sleep to allow source check
sleep 5

me=$(basename "$0")

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
if ! cron_job_exists "$cron_cron"; then
    add_cron_job "$cron_cron"
fi


## Make a file to check if installation was successful
touch "$clientinstallcon"
echo "yes" > "$clientinstallcon"