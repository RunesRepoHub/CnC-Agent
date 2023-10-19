#!/bin/bash

# Source the configuration script
source ~/CnC-Agent/config.sh

me=$(basename "$0")
databaseip=$(cat "$dbip")

# Function to check if a package is installed
package_installed() {
    local package_name=$1
    if dpkg -l | grep -q "ii  $package_name "; then
        echo "Installed"
    else
        echo "Not Installed"
    fi
}

API_READ_ENDPOINT="http://$databaseip:3000/read/packages"
API_CREATE_ENDPOINT="http://$databaseip:3000/create/packages"
API_UPDATE_ENDPOINT="http://$databaseip:3000/update/packages"

# Define your hostname
hostname="$HOSTNAME"

# Function to send an HTTP GET request to check if the package data exists in the database
send_read_request() {
    local package_name="$1"
    local response=$(curl -s "$API_READ_ENDPOINT/$hostname/$package_name")
    echo "$response"
}

# Function to send an HTTP POST request to create a package record
send_create_request() {
    local data="$1"
    curl -X POST -H "Content-Type: application/json" -d "$data" "$API_CREATE_ENDPOINT"
}

# Function to send an HTTP PUT request to update a package record
send_update_request() {
    local package_name="$1"
    local data="$2"
    curl -X PUT -H "Content-Type: application/json" -d "$data" "$API_UPDATE_ENDPOINT/$hostname/$package_name"
}

# Retrieve the list of installed packages
installed_packages=$(dpkg -l | awk '/^ii/ {print $2}')

# Loop through the installed packages and update the database via the API
for package_name in $installed_packages; do
    package_status=$(package_installed "$package_name")
    data="{\"hostname\":\"$hostname\",\"packagename\":\"$package_name\",\"status\":\"$package_status\"}"

    # Check if the package is in the database
    response=$(send_read_request "$package_name")
    
    if [ -z "$response" ]; then
        # Data doesn't exist, so create a new entry
        response=$(send_create_request "$data")
        echo "Data inserted from $me for package $package_name."
    else
        # Data exists, so update it
        response=$(send_update_request "$package_name" "$data")
        echo "Data updated from $me for package $package_name."
    fi
done

echo "All package data is up to date."
