#!/bin/bash
# Source the configuration script
source ~/CnC-WebGUI/config.sh
source ~/CnC-Agent/config.sh

me=$(basename "$0")
databaseip=$(cat "$dbip")

# Set the hostname variable
hostname=$(echo $HOSTNAME)

# Set the variables you want to compare or insert/update
ip_address=$(hostname -I | awk '{print $1}')
mac_address=$(cat /sys/class/net/*/address | sed -n '1 p')
packages=$(apt-get -q -y --ignore-hold --allow-change-held-packages --allow-unauthenticated -s dist-upgrade | /bin/grep  ^Inst | wc -l)

if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$NAME
    VER=$VERSION_ID
else
    OS="Unknown"
    VER="Unknown"
fi

distro="$OS $VER"

# Define the URL for reading data
READ_API_ENDPOINT="http://$databaseip:3000/read/info/$hostname"

# Fetch existing data from the API
existing_data=$(curl -s "$READ_API_ENDPOINT")

if [ -n "$existing_data" ]; then
  echo "Data for hostname $hostname exists. Updating..."
  # Extract existing data and compare with new data
  existing_ip_address=$(echo "$existing_data" | jq -r .ipaddress)
  existing_mac_address=$(echo "$existing_data" | jq -r .macaddress)
  existing_distro=$(echo "$existing_data" | jq -r .distro)
  existing_packages=$(echo "$existing_data" | jq -r .packages)

  # Compare existing data with new data
  if [ "$existing_ip_address" != "$ip_address" ]; then
    ip_address="$existing_ip_address"
  fi

  if [ "$existing_mac_address" != "$mac_address" ]; then
    mac_address="$existing_mac_address"
  fi

  if [ "$existing_distro" != "$distro" ]; then
    distro="$existing_distro"
  fi

  if [ "$existing_packages" != "$packages" ]; then
    packages="$existing_packages"
  fi

  # Prepare the data for update
  DATA='{
      "hostname": "'"$hostname"'",
      "ipaddress": "'"$ip_address"'",
      "macaddress": "'"$mac_address"'",
      "distro": "'"$distro"'",
      "packages": "'"$packages"'"
  }'

  # Send a PUT request to update the data
  UPDATE_API_ENDPOINT="http://$databaseip:3000/update/info/$hostname"
  response=$(curl -X PUT -H "Content-Type: application/json" -d "$DATA" "$UPDATE_API_ENDPOINT")

  if [ "$response" == "Data updated" ]; then
    echo "Data updated from $me."
  else
    echo "Data update failed."
  fi
else
  echo "Data for hostname $hostname does not exist. Inserting..."

  # Prepare the data for insertion
  DATA='{
      "hostname": "'"$hostname"'",
      "ipaddress": "'"$ip_address"'",
      "macaddress": "'"$mac_address"'",
      "distro": "'"$distro"'",
      "packages": "'"$packages"'"
  }'

  # Send a POST request to insert the data
  CREATE_API_ENDPOINT="http://$databaseip:3000/create/info"
  response=$(curl -X POST -H "Content-Type: application/json" -d "$DATA" "$CREATE_API_ENDPOINT")

  if [ "$response" == "Data inserted" ]; then
    echo "Data inserted from $me."
  else
    echo "Data insert failed."
  fi
fi
