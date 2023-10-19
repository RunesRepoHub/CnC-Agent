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
    local package_info
    while read -r package_line; do
        # Extract package name and version from the dpkg -l output
        package_name=$(echo "$package_line" | awk '{print $2}')
        package_version=$(echo "$package_line" | awk '{print $3}')
        package_info+="\"$package_name\": \"$package_version\", "
    done < <(dpkg -l | awk '/^ii/ {print $2, $3}')
    package_info="${package_info%,*}"  # Remove the trailing comma
    echo "{$package_info}"
}

# Fetch data from the API for the specified hostname
read_response=$(curl -s "$API_READ_ENDPOINT/$HOSTNAME")

# Get information about all installed packages
package_info_json=$(get_installed_packages)

# Modify the hostname to escape double quotes
escaped_hostname=$(echo "$HOSTNAME" | sed 's/"/\\"/g')

if [ -n "$read_response" ]; then
    # Data for this host already exists, so update it
    DATA=$(cat <<EOF
    {
        "hostname": "$escaped_hostname",
        "packages": $package_info_json
    }
EOF
)
    # Update the data in the database
    response=$(curl -X PUT -H "Content-Type: application/json" -d "$DATA" "$API_UPDATE_ENDPOINT/$escaped_hostname" >/dev/null 2>&1)
    echo "Data updated from $me."
else
    # Data doesn't exist, so create a new entry
    DATA=$(cat <<EOF
    {
        "hostname": "$escaped_hostname",
        "packages": $package_info_json
    }
EOF
)
    # Create a new entry in the database
    response=$(curl -X POST -H "Content-Type: application/json" -d "$DATA" "$API_CREATE_ENDPOINT" >/dev/null 2>&1)
    echo "Data inserted from $me."
fi
