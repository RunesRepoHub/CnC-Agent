#!/bin/bash

# Source the configuration script
source ~/CnC-Agent/config.sh

me=$(basename "$0")

# Function to check if a package is installed
package_installed() {
    local package_name=$1
    if dpkg -l | grep -q "ii  $package_name "; then
        echo "Installed"
    else
        echo "Not Installed"
    fi
}

# Define your hostname
hostname="$HOSTNAME"

# Function to send an HTTP POST request to create a package record
send_create_request() {
    local data="$1"
    curl -X POST -H "Content-Type: application/json" -d "$data" "$API_CREATE_ENDPOINT"
}

# Function to send an HTTP PUT request to update a package record
send_update_request() {
    local hostname="$1"
    local package_name="$2"
    local data="$3"
    curl -X PUT -H "Content-Type: application/json" -d "$data" "$API_UPDATE_ENDPOINT/$hostname/$package_name"
}

# Retrieve the list of installed packages
installed_packages=$(dpkg -l | awk '/^ii/ {print $2}')

# Loop through the installed packages and update the database via the API
for package_name in $installed_packages; do
    package_status=$(package_installed "$package_name")
    data="{\"hostname\":\"$hostname\",\"packagename\":\"$package_name\",\"status\":\"$package_status\"}"
    
    # Check if the package is in the database
    response=$(send_create_request "$data")
    echo "Data inserted/updated from $me for package $package_name."
done

# Send a request to the API to check for removed packages and update their status
curl -X PUT "$API_UPDATE_ENDPOINT/$hostname"

echo "All package data is up to date."
