#!/bin/bash
# Backup minecraft docker containers to somewhere else (preferably another drive!)

# TODO: Allow you to specify the paths via command line args, but fallback to these defaults

# The path of the directory that we want to tar and compress
folderToTar=./docker

# The path of the directory that the backup will be placed in
outputDir=/media/BigData/Vault/minecraft/mc-1.18.1-survival

# TODO: Allow you to specify the out file name with command line args
outFilePrefix=mc-backup

# Generate a unique file name based on the current date and time
dateFormat=$(date '+%F-%Hh-%Mm')
outFileName="$outFilePrefix-$dateFormat.tar.gz"

# Assume that the docker-compose file is
composeFile=$folderToTar/docker-compose.yml

# Echo some useful info
echo "Docker Compose file path: $composeFile"
echo "Tar file name: $outFileName"

# TODO: Add some messaging on the server about this so players know

# Tell the minecraft world to save all so that the files in the 
echo "RCON Save command to the MC server!"
docker-compose -f $composeFile exec mc rcon-cli save-all

# Tar the folder that we want to the given file name we want
echo "Starting Tar..."
tar -zcf $outFileName $folderToTar
echo "Tar Complete!"

# Move this tar file to the output directory that we want
mv $outFileName $outputDir
echo "Moved tar to output dir!"