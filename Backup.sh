#!/bin/bash

# Backup Plex database.

# Script Tested on:
# Ubuntu 16.04, Working

# Plex Database Location.  The trailing slash is needed
plexDatabase="/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/"

# Backup Directory
backupDirectory="/backup-60GB/Backup/Plex-data"

# Log file for script's output named with
# the script's name, date, and time of execution.
scriptName=$(basename ${0})
log="/backup-60GB/Backup/log/${scriptName}_`date +%m%d%y%H%M%S`.log"

# Check for root permissions
if [[ $EUID -ne 0 ]]; then
  echo -e "${scriptName} requires root privledges.\n"
  echo -e "sudo $0 $*\n"
  exit 1
fi

# Create Log
echo -e "Staring Backup of Plex Database." > $log 2>&1
echo -e "*********************************************************\n" >> $log 2>&1

# Stop Plex
echo -e "\n\nStopping Plex Media Server." >> $log 2>&1
echo -e "*********************************************************\n" >> $log 2>&1
sudo service plexmediaserver stop >> $log 2>&1

# Backup database
echo -e "\n\nStarting Backup." >> $log 2>&1
echo -e "*********************************************************\n" >> $log 2>&1
sudo rsync -av --delete "$plexDatabase" "$backupDirectory" >> $log 2>&1

# Restart Plex
echo -e "\n\nStarting Plex Media Server." >> $log 2>&1
echo -e "*********************************************************\n" >> $log 2>&1
sudo service plexmediaserver start >> $log 2>&1

# Done
echo -e "\n\nBackup Complete." >> $log 2>&1
