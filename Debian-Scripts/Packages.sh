#!/bin/bash

# Source the configuration script
source ~/CnC-Agent/config.sh

databaseip=$(cat "$dbip")
me=$(basename "$0")

# Define your REST API endpoints for reading, creating, and updating data
API_READ_ENDPOINT="http://$databaseip:3000/read/packages"
API_CREATE_ENDPOINT="http://$databaseip:3000/create/packages"
API_UPDATE_ENDPOINT="http://$databaseip:3000/update/packages"

# Function to retrieve all installed packages and their versions
get_installed_packages() {
    dpkg -l | awk '/^ii/ {print $2, $3}'
}

# Retrieve the database data for the specified hostname
get_database_packages() {
    local hostname="$1"
    curl -s "$API_READ_ENDPOINT/$hostname"
}

# Check if there are installed packages
installed_packages=$(get_installed_packages)
if [ -z "$installed_packages" ]; then
    echo "No installed packages found. Exiting."
    exit 0
fi

# Compare the collected data with the database data
hostname="$HOSTNAME"
db_packages_json=$(get_database_packages "$hostname")

for package_info in $installed_packages; do
    package_name=$(echo "$package_info" | awk '{print $1}')
    package_version=$(echo "$package_info" | awk '{print $2}')

    data='{"hostname":"'"$hostname"'","package":"'"$package_name $package_version"'"}'

    if ! echo "$db_packages_json" | grep -q "$package_name $package_version"; then
        if [ -z "$db_packages_json" ] || [ "$db_packages_json" == "null" ]; then
            # Data doesn't exist, so create a new entry
            response=$(curl -X POST -H "Content-Type: application/json" -d "$data" "$API_CREATE_ENDPOINT")
            echo "Data inserted from $me."
        else
            # Data exists, so update it
            response=$(curl -X PUT -H "Content-Type: application/json" -d "$data" "$API_UPDATE_ENDPOINT/$hostname")
            echo "Data updated from $me."
        fi
    fi
done

echo "All package data is up to date."