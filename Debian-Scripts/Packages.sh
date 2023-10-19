#!/bin/bash

# Source the configuration script
source ~/CnC-Agent/config.sh

databaseip=$(cat "$dbip")

# Define a function to check if a package is installed
package_installed() {
    local package_name=$1
    if dpkg -l | grep -q "ii  $package_name "; then
        echo "Installed"
    else
        echo "Not Installed"
    fi
}

# Define your REST API endpoints for creating and updating data
API_CREATE_ENDPOINT="http://$databaseip:3000/create/packages"
API_UPDATE_ENDPOINT="http://$databaseip:3000/update/packages"

# Get the list of installed packages, excluding the hostname
installed_packages=$(dpkg -l | awk '/^ii/ {print $2}' | grep -v "hostname")

# Escape the hostname to handle double quotes
escaped_hostname=$(echo "$HOSTNAME" | sed 's/"/\\"/g')

# Iterate through the list of installed packages and create or update the database records
for package_name in $installed_packages; do
    # Check if the package is installed
    package_status="Installed"
    
    DATA=$(cat <<EOF
    {
        "hostname": "$escaped_hostname",
        "packagename": "$package_name",
        "installed": "$package_status"
    }
EOF
)
    # Send a request to check if the data already exists in the database
    response=$(curl -s -X GET "$API_UPDATE_ENDPOINT/$escaped_hostname/$package_name")
    
    if [ -z "$response" ]; then
        # Data doesn't exist, so create a new entry
        response=$(curl -s -X POST -H "Content-Type: application/json" -d "$DATA" "$API_CREATE_ENDPOINT")
        echo "Data inserted for package $package_name."
    else
        # Data already exists, no need to update or create
        echo "Data already exists for package $package_name."
    fi
done
