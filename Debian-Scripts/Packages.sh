#!/bin/bash

# Source the configuration script
source ~/CnC-Agent/config.sh

databaseip=$(cat "$dbip")
me=$(basename "$0")

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

# Modify the hostname to escape double quotes
escaped_hostname=$(echo "$HOSTNAME" | sed 's/"/\\"/g')

# Get the list of installed packages
installed_packages=$(dpkg -l | awk '/^ii/ {print $2}')

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
    # Send a request to create or update the data in the database
    response=$(curl -s -X POST -H "Content-Type: application/json" -d "$DATA" "$API_CREATE_ENDPOINT")

    if [ -z "$response" ]; then
        # Data doesn't exist, so create a new entry
        echo "Data inserted for package $package_name."
    else
        # Data already exists, so update it
        response=$(curl -s -X PUT -H "Content-Type: application/json" -d "$DATA" "$API_UPDATE_ENDPOINT/$escaped_hostname/$package_name")
        echo "Data updated for package $package_name."
    fi
done
