#!/bin/bash
source /root/.profile

/usr/bin/tar -czf /tmp/backupRclone.tar.gz /home/ /root/

/usr/bin/rclone sync /tmp/backupRclone.tar.gz webservice:/backups/backupRclone.tar.gz --bwlimit 15M --onedrive-no-versions

/usr/bin/rm /tmp/backupRclone.tar.gz
