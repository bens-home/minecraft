#!/bin/bash
# Backup minecraft docker containers to somewhere else (preferably another drive!)
# This is assuming hard paths and should be updated

# The path of the directory that we want to tar and compress. This assumes that this script is 
# located one directory about the "docker" folder that has the MC data and docker-compose file
folderToTar=./docker

# The path of the directory that the backup will be placed in
outputDir=/media/BigData/Vault/minecraft/mc-1.18.1-survival

# Generate a unique file name based on the current date and time
dateFormat=$(date '+%F-%Hh-%Mm')
outFileName="mc-backup-$dateFormat.tar.gz"

# Assume that the docker-compose file is
composeFile=$folderToTar/docker-compose.yml

echo "Using compose file: $composeFile"

echo "Backing up to $outFileName"

# Tell the minecraft world to save all so that the files in the 
echo "RCON Save command to the MC server!"
docker-compose -f $composeFile exec mc rcon-cli save-all

echo "Starting Tar..."
tar -zcf $outFileName $folderToTar
echo "Tar Complete!"

mv $outFileName $outputDir
echo "Moved tar to output dir!"