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

# Define your REST API endpoints for reading, creating, and updating data
API_READ_ENDPOINT="http://$databaseip:3000/read/packages"
API_CREATE_ENDPOINT="http://$databaseip:3000/create/packages"
API_UPDATE_ENDPOINT="http://$databaseip:3000/update/packages"

# Modify the hostname to escape double quotes
escaped_hostname=$(echo "$HOSTNAME" | sed 's/"/\\"/g')

# Fetch data from the API for the specified hostname
read_response=$(curl -s "$API_READ_ENDPOINT/$escaped_hostname")

# If data for the hostname already exists, update it; otherwise, create a new entry
if [ -n "$read_response" ]; then
    # Data for this host already exists, so update it
    DATA=$(cat <<EOF
    {
        "hostname": "$escaped_hostname",
        "git": "$(package_installed "git")",
        "wget": "$(package_installed "wget")",
        "sudo": "$(package_installed "sudo")",
        "python": "$(package_installed "python")",
        "python3": "$(package_installed "python3")",
        "nettools": "$(package_installed "net-tools")",
        "mysql": "$(package_installed "mysql-server")",
        "libpython": "$(package_installed "libpython3.7")",
        "dockercecli": "$(package_installed "docker-ce-cli")",
        "dockercomposeplugin": "$(package_installed "docker-compose-plugin")",
        "curl": "$(package_installed "curl")",
        "containerd": "$(package_installed "containerd.io")"
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
        "git": "$(package_installed "git")",
        "wget": "$(package_installed "wget")",
        "sudo": "$(package_installed "sudo")",
        "python": "$(package_installed "python")",
        "python3": "$(package_installed "python3")",
        "nettools": "$(package_installed "net-tools")",
        "mysql": "$(package_installed "mysql-server")",
        "libpython": "$(package_installed "libpython3.7")",
        "dockercecli": "$(package_installed "docker-ce-cli")",
        "dockercomposeplugin": "$(package_installed "docker-compose-plugin")",
        "curl": "$(package_installed "curl")",
        "containerd": "$(package_installed "containerd.io")"
    }
EOF
)
    # Create a new entry in the database
    response=$(curl -X POST -H "Content-Type: application/json" -d "$DATA" "$API_CREATE_ENDPOINT" >/dev/null 2>&1)
    echo "Data inserted from $me."
fi