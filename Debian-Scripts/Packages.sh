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

# Function to retrieve the database data for the specified hostname
get_database_packages() {
    local hostname="$1"
    local db_data=$(curl -s "$API_READ_ENDPOINT/$hostname")
    if [ -z "$db_data" ]; then
        echo "[]"
    else
        echo "$db_data" | jq -c '.[0].packages'
    fi
}

# Compare the collected data with the database data for each package
installed_packages=$(get_installed_packages)
for package_info in $installed_packages; do
    package_name=$(echo "$package_info" | awk '{print $1}')
    package_version=$(echo "$package_info" | awk '{print $2}')

    db_packages_json=$(get_database_packages "$HOSTNAME")
    
    if ! echo "$db_packages_json" | grep -q "\"packagename\": \"$package_name\", \"packageversion\": \"$package_version\""; then
        # Data is different, so update or insert it
        DATA=$(cat <<EOF
        {
            "hostname": "$HOSTNAME",
            "packagename": "$package_name",
            "packageversion": "$package_version"
        }
EOF
)
        if [ -z "$db_packages_json" ] || [ "$db_packages_json" == "null" ]; then
            # Data doesn't exist, so create a new entry
            response=$(curl -X POST -H "Content-Type: application/json" -d "$DATA" "$API_CREATE_ENDPOINT" >/dev/null 2>&1)
            echo "Data inserted from $me."
        else {
            # Data exists, so update it
            response=$(curl -X PUT -H "Content-Type: application/json" -d "$DATA" "$API_UPDATE_ENDPOINT/$HOSTNAME" >/dev/null 2>&1)
            echo "Data updated from $me."
        }
    fi
done

echo "All package data is up to date."
