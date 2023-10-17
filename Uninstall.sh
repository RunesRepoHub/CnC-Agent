sudo sed -i '/Packages\.sh\|Cronjob\.sh\|Overview\.sh/d' /etc/crontab

# Define the paths of the scripts you want to remove from the crontab
pack_cron="/root/CnC-Agent/Debian-Scripts/Packages.sh"
over_cron="/root/CnC-Agent/Debian-Scripts/Overview.sh"
cron_cron="/root/CnC-Agent/Debian-Scripts/Cronjob.sh"

# Get the current user's crontab
current_user=$(whoami)

# Display the current crontab and remove the specified jobs
crontab -l | grep -v "$pack_cron" | grep -v "$over_cron" | grep -v "$cron_cron" | crontab -

echo "Cron jobs removed from your crontab."

# Remove both repos
rm -rf ~/CnC-Agent