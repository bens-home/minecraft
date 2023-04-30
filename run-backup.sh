#!/bin/bash
# Backup minecraft docker containers to somewhere else (preferably another drive!)
# Don't judge my bash script skills here, I'm relatively new at this! 

# Print out the useage/help of this script
function PrintHelp 
{ 
    echo ""
    echo "Useage:   ./run-backup.sh [OPTIONS]"
    echo ""
    echo "Commands"
    echo "  -h      Help                    Print this help message"
    echo "  -f      Folder to Tar           Specifiy the folder that should be tar'd"
    echo "  -o      Output folder           Specify where the tar file should be put"
    echo "  -c      Compose file            Override which docker-compose.yml file to use"
    exit 1;
}

# The path of the directory that we want to tar and compress
folderToTar=./docker

# The path of the directory that the backup will be placed in
outputDir=./mc-backup

# Iterate the optional args!
while getopts ":f:o:c:" flag;
do
    case "${flag}" in
        f) folderToTar=${OPTARG};;
        o) outputDir=${OPTARG};;
        c) composeFileOverride=${OPTARG};;
        *) 
            PrintHelp
            ;;
    esac
done

# By default, assume the compose file is in the folder to tar at the top level
composeFileDefault=$folderToTar/docker-compose.yml

if test -z "$composeFileOverride" 
then
      composeFile=$composeFileDefault
else
      composeFile=$composeFileOverride
fi

# Generate a unique file name based on the current date and time
dateFormat=$(date '+%F-%Hh-%Mm')
outFileName="mc-backup-$dateFormat.tar.gz"

outFilePath="$outputDir/$outFileName"

echo "======================================"
echo "  Folder To Tar:        $folderToTar"
echo "  Output directory:     $outputDir"
echo "  Out file name:        $outFileName"
echo "  Out File Path:        $outFilePath"
echo "  Docker Compose File:  $composeFile"
echo "======================================"

# # TODO: Add some messaging on the server about this so players know

# Tell the minecraft world to save all so that the files in the 
echo ""
echo "RCON Save command to the MC server!"
docker-compose -f $composeFile exec mc rcon-cli save-all

result="$?"

if [ $? -eq 0 ]; then
   echo "Successfully saved the minecraft world!"
else
   echo "Failed to save minecraft world, is it running? Error code $?"
fi

echo "Creating output director '$outputDir'"
mkdir -p $outputDir

echo ""
# Tar the folder that we want to the given file name we want
echo "Starting Tar..."
tar -czf $outFilePath $folderToTar

result="$?"

if [ $? -eq 0 ]; then
    echo "Tar Complete!"
else
   echo "Uh oh! Failed to tar the folder '$folderToTar': Error code $?"
fi

result="$?"

if [ $? -eq 0 ]; then
    echo "======================================"
    echo "Hoozah! Minecraft was succesfully backed up to: "
    echo "      $outputDir/$outFileName"
    echo "To restore the data, unzip the archive with 'tar -xzvf $outFileName' and copy its contents to replace the 'docker' folder."
else
   echo "Uh oh! Failed to move the file: Error code $?"
fi