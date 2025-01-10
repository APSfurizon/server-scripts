#!/bin/bash

/usr/bin/tar -czvf /tmp/backupRclone.tar.gz /home/ /root/

/usr/bin/rclone sync /tmp/backupRclone.tar.gz webservice:/backups/backupRclone.tar.gz -P --stats=1s --bwlimit 15M --onedrive-no-versions

/usr/bin/rm /tmp/backupRclone.tar.gz
