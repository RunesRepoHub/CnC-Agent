#!/bin/bash

# Source the configuration script
source ~/CnC-Agent/config.sh

## Get database IP address
echo -e "${Green}Input Database IP${NC}"
read -p "Database IP: " databaseip

## Save database IP address
touch "$dbip"
echo "$databaseip" > "$dbip"

sleep 3 


bash "$pack_cron_CI"
bash "$over_cron_CI"
bash "$cron_cron_CI"