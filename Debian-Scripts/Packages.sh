#!/bin/bash

# Source the configuration script
source ~/CnC-Agent/config.sh

databaseip=$(cat "$dbip")
me=$(basename "$0")

# Define your REST API endpoints for reading, creating, and updating data
API_READ_ENDPOINT="http://$databaseip:3000/read/packages"
API_CREATE_ENDPOINT="http://$databaseip:3000/create/packages"
API_UPDATE_ENDPOINT="http://$databaseip:3000/update/packages"

# Function to retrieve all installed packages
get_installed_packages() {
    dpkg -l | awk '/^ii/ {print $2}'
}

# Retrieve the database data for the specified hostname
get_database_packages() {
    local hostname="$1"
    curl -s "$API_READ_ENDPOINT/$hostname"
}

# Function to check if a package is installed and return "Installed" or "Not Installed"
check_installed() {
    local package_name="$1"
    dpkg -l | grep -q "^ii $package_name " && echo "Installed" || echo "Not Installed"
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

for package_name in $installed_packages; do
    # Check if the package is in the database
    if echo "$db_packages_json" | jq -e '.[] | select(.hostname == "'"${hostname}"'" and .packagename == "'"${package_name}"'")' >/dev/null; then
        echo "Data for package $package_name is up to date."
    else
        # Data doesn't exist, so create a new entry with "Installed" or "Not Installed" status
        status=$(check_installed "$package_name")
        data='{"hostname":"'"$hostname"'","packagename":"'"$package_name"'","installed":"'"$status"'"}'
        response=$(curl -X POST -H "Content-Type: application/json" -d "$data" "$API_CREATE_ENDPOINT")
        echo "Data inserted from $me for package $package_name. Status: $status"
    fi
done

echo "All package data is up to date."
