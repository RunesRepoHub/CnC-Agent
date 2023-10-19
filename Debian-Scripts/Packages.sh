#!/bin/bash

# Source the configuration script
source ~/CnC-Agent/config.sh

databaseip=$(cat "$dbip")

# Define your REST API endpoints for reading, creating, and updating data
API_READ_ENDPOINT="http://$databaseip:3000/read/packages"
API_CREATE_ENDPOINT="http://$databaseip:3000/create/packages"
API_UPDATE_ENDPOINT="http://$databaseip:3000/update/packages"

# Get the list of installed packages, excluding the hostname
installed_packages=$(dpkg -l | awk '/^ii/ {print $2}' | grep -v "hostname")

# Escape the hostname to handle double quotes
escaped_hostname=$(echo "$HOSTNAME" | sed 's/"/\\"/g')

# Check if the database is empty
database_data=$(curl -s "$API_READ_ENDPOINT")

if [ "$database_data" == "[]" ]; then
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
        # Send a request to create the data in the database
        response=$(curl -s -X POST -H "Content-Type: application/json" -d "$DATA" "$API_CREATE_ENDPOINT")

        echo "Data inserted for package $package_name."
    done
else
    for package_name in $installed_packages; do
        # Check if the data for the hostname and package name already exists in the database_data
        existing_data=$(echo "$database_data" | jq ".[] | select(.hostname == \"$escaped_hostname\" and .packagename == \"$package_name\")")

        if [ -z "$existing_data" ]; then
            # Data doesn't exist, so create a new entry
            package_status="Installed"

            DATA=$(cat <<EOF
            {
                "hostname": "$escaped_hostname",
                "packagename": "$package_name",
                "installed": "$package_status"
            }
EOF
)
            # Send a request to create the data in the database
            response=$(curl -s -X POST -H "Content-Type: application/json" -d "$DATA" "$API_CREATE_ENDPOINT")

            echo "Data inserted for package $package_name."
        else
            echo "Data already exists for package $package_name."
        fi
    done
fi
