# Source the configuration script
# Source the configuration script
source ~/CnC-WebGUI/config.sh
source ~/CnC-Agent/config.sh


databaseip=$(cat "$dbip")
me=$(basename "$0")


# Escape double quotes in variables
HOSTNAME=$(echo "$HOSTNAME" | sed 's/"/\\"/g')
GIT=$(apt list --installed 2>/dev/null | grep -i git/ | awk '{print $2}' | sed 's/"/\\"/g')
WGET=$(apt list --installed 2>/dev/null | grep -i wget | awk '{print $2}' | sed 's/"/\\"/g')
SUDO=$(apt list --installed 2>/dev/null | grep -i sudo | awk '{print $2}' | sed 's/"/\\"/g')
PYTHON=$(apt list --installed 2>/dev/null | grep -i python/ | awk '{print $2}' | sed 's/"/\\"/g')
PYTHON3=$(apt list --installed 2>/dev/null | grep -i python3/ | awk '{print $2}' | sed 's/"/\\"/g')
NETTOOLS=$(apt list --installed 2>/dev/null | grep -i net-tools | awk '{print $2}' | sed 's/"/\\"/g')
MYSQL=$(apt list --installed 2>/dev/null | grep -i mysql-server/ | awk '{print $2}' | sed 's/"/\\"/g')
LIBPYTHON=$(apt list --installed 2>/dev/null | grep -i libpython3.7/ | awk '{print $2}' | sed 's/"/\\"/g')
DOCKERCECLI=$(apt list --installed 2>/dev/null | grep -i docker-ce-cli | awk '{print $2}' | sed 's/"/\\"/g')
DOCKERCOMPOSEPLUGIN=$(apt list --installed 2>/dev/null | grep -i docker-compose-plugin | awk '{print $2}' | sed 's/"/\\"/g')
CURL=$(apt list --installed 2>/dev/null | grep -i curl/ | awk '{print $2}' | sed 's/"/\\"/g')
CONTAINERD=$(apt list --installed 2>/dev/null | grep -i containerd.io | awk '{print $2}' | sed 's/"/\\"/g')

# Define your REST API endpoint for querying and updating data
API_ENDPOINT="http://$databaseip:3000/create/packages"

# Define the data to be sent to the API
DATA=$(cat <<EOF
{
    "hostname": "$HOSTNAME",
    "git": "$(if [ -n "$GIT" ]; then echo "Installed"; else echo "Not Installed"; fi)",
    "wget": "$(if [ -n "$WGET" ]; then echo "Installed"; else echo "Not Installed"; fi)",
    "sudo": "$(if [ -n "$SUDO" ]; then echo "Installed"; else echo "Not Installed"; fi)",
    "python": "$(if [ -n "$PYTHON" ]; then echo "Installed"; else echo "Not Installed"; fi)",
    "python3": "$(if [ -n "$PYTHON3" ]; then echo "Installed"; else echo "Not Installed"; fi)",
    "nettools": "$(if [ -n "$NETTOOLS" ]; then echo "Installed"; else echo "Not Installed"; fi)",
    "mysql": "$(if [ -n "$MYSQL" ]; then echo "Installed"; else echo "Not Installed"; fi)",
    "libpython": "$(if [ -n "$LIBPYTHON" ]; then echo "Installed"; else echo "Not Installed"; fi)",
    "dockercecli": "$(if [ -n "$DOCKERCECLI" ]; then echo "Installed"; else echo "Not Installed"; fi)",
    "dockercomposeplugin": "$(if [ -n "$DOCKERCOMPOSEPLUGIN" ]; then echo "Installed"; else echo "Not Installed"; fi)",
    "curl": "$(if [ -n "$CURL" ]; then echo "Installed"; else echo "Not Installed"; fi)",
    "containerd": "$(if [ -n "$CONTAINERD" ]; then echo "Installed"; else echo "Not Installed"; fi)"
}
EOF
)

# Debugging: Print the data being sent
# echo "Sending data: $DATA"

# Send a POST request to the API to update or insert data
response=$(curl -X POST -H "Content-Type: application/json" -d "$DATA" "$API_ENDPOINT" >/dev/null 2>&1) 

# Debugging: Print the response from the API
# echo "API response: $response"

# Check the response from the API
# if [ "$response" == "Data updated" ]; then
#     echo "Data updated from $me."
# else
#     echo "Data inserted from $me."
# fi
