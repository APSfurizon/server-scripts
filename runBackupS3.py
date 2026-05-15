#!/usr/bin/python

from os import listdir, remove, getenv
from os.path import isfile, join
import datetime
import subprocess

STUFF_BACKUP = False

BACKUP_DIR_POSTGRES = "/home/postgres/backups/"
BACKUP_DIR_STUFF = "/root/backups/"

MAX_FILE_NO = 7

COMMAND_POSTGRES = "sudo -u postgres pg_dumpall | gzip > %s" # Restore with sudo -u postgres psql -f %s
COMMAND_STUFF = "tar -czf %s /etc/ /var/backups/ /var/log/ /var/mail/ /var/spool/ /var/www/ /mnt/garage/ssd-a/ /mnt/garage/ssd-b/" # Restore with tar -xvf %s


def deleteOlder(path : str, prefix : str, postfix : str):
	backupFileNames = sorted([f for f in listdir(path) if (isfile(join(path, f)) and f.startswith(prefix) and f.endswith(postfix))])
	while(len(backupFileNames) > MAX_FILE_NO):
		print(f"Removing {backupFileNames[0]}")
		remove(join(path, backupFileNames[0]))
		backupFileNames.pop(0)

def genFileName(prefix : str, postfix : str):
	return prefix + "_" + datetime.datetime.now(datetime.UTC).strftime('%Y%m%d-%H%M%S') + "_" + postfix

def runBackup(prefix : str, postfix : str, path : str, command : str):
	deleteOlder(path, prefix, postfix)
	name = join(path, genFileName(prefix, postfix))
	process = subprocess.Popen(command % name, shell=True)
	process.wait()

if(STUFF_BACKUP):
	runBackup("all_postres", "backup.sql.gz", BACKUP_DIR_POSTGRES, COMMAND_POSTGRES)
	runBackup("stuff", "backup.tar.gz", BACKUP_DIR_STUFF, COMMAND_STUFF)
