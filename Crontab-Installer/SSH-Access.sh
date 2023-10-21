#!/bin/bash

# Source the configuration script
source ~/CnC-Agent/config.sh

ssh_password=$(cat "$sshpasswordpath")

# Get the server name from the hostname
server_name=$(hostname)

# Get the IP address using the 'hostname' command
ip_address=$(hostname -I | awk '{print $1}')

# Get the SSH username from the current user
ssh_username=$(whoami)

# Send the data with curl
curl -X POST -H "Content-Type: application/json" -d '{
  "name": "'"$server_name"'",
  "ip_address": "'"$ip_address"'",
  "ssh_username": "'"$ssh_username"'",
  "ssh_password": "'"$ssh_password"'"
}' http://$databaseip:3001/servers
