#!/bin/bash

# Source the configuration script
source ~/CnC-WebGUI/config.sh

# Add a sleep to allow source check
sleep 5

me=$(basename "$0")
export DEBIAN_FRONTEND=noninteractive

## Get database IP address
read -p "Database IP: " databaseip

## Save database IP address
touch "$dbip"
echo "$databaseip" > "$dbip"

# Function to remove and add a cron job
remove_and_add_cron_job() {
    local script_name="$1"
    local cron_command="5 * * * * bash $script_name"
    
    # Remove existing cron job with the same script name
    crontab -l | grep -v "$script_name" | crontab -

    # Add the new cron job
    { crontab -l; echo "$cron_command"; } | crontab -
}

# Check/Setup Packages Reporting via cron
ln -s "$pack_cron" /usr/bin/ > /dev/null 2>&1

# Remove and add the cron job for packages.sh
remove_and_add_cron_job "$pack_cron"

## Run Packages Reporting for the first time
bash "$pack_cron"

# Check/Setup Packages Reporting via cron
ln -s "$over_cron" /usr/bin/ > /dev/null 2>&1

# Remove and add the cron job for overview.sh
remove_and_add_cron_job "$over_cron"

## Run Packages Reporting for the first time
bash "$over_cron"

# Check/Setup Packages Reporting via cron
ln -s "$cron_cron" /usr/bin/ > /dev/null 2>&1

# Remove and add the cron job for cronjob.sh
remove_and_add_cron_job "$cron_cron"

## Run Packages Reporting for the first time
bash "$cron_cron"
