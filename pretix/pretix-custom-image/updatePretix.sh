#!/bin/bash
set -e #crashes the script on errors

echo "Stopping pretix"
systemctl stop pretix.service
echo "Backup in progress"
sudo -H -u pretix -i PWD=/home/pretix bash -c '/usr/bin/python /home/pretix/backups/runBackup.py'
echo "Pulling and building pretix"
docker pull pretix/standalone:stable
docker build /root/pretix-custom-image/pretix-custom-image -t custompretix --no-cache
echo "Restarting pretix AND waiting 20 secs to be sure it's up and running"
systemctl start pretix.service
sleep 20
echo "Executing upgrade"
docker exec -it pretix.service pretix upgrade
systemctl restart pretix.service
echo "Done!"
