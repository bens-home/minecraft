# Minecraft
This is my setup for running some various minecraft servers on my home network so that I can play with friends. 

It uses the [itzg/minecraft-server](https://hub.docker.com/r/itzg/minecraft-server) Docker image to run. This is just
a normal survival server and doesn't run with any mods. Check out the official docker image docs to see how to 
run this with mods on the server if desired (I personally have not done this, good luck!).

## Getting Started

Run the server with the following command from the `docker` directory:

```
docker-compose up -d
```

This will start the container detached. When it is started for the first time it will create a `data` folder 
in the same directory as the `docker-compose.yml` file that contains all the normal Minecraft data like the 
saved world and `ops.json` file. The `data` folder is ignored by Git, as is any `ops.json` file that may be outside of 
it. 

The server will be running on post `42071` by default, with a set seed of `387579004540251912`. You can change these in the 
`docker-compose.yml` file to be whatever you want. If you want a random seed, then just delete the `SEED` enviornment variable 
from the compose file. 

This is set up to restart the container unless it is stopped with `docker-compose down`, so it will be automatically restarted
when the server is booted. 

## Executing commands on the server

We can use the `rcon-cli` interface to send commands to the Minecraft server through Docker. 
For example, we can tell the server to save the world data with the following: 

```
docker-compose -f PATH/TO/docker-compose.yml exec mc rcon-cli save-all
```

Obviously you need to replace the `PATH/TO/docker-compose.yml` with the actual path to the minecraft `docker-compose.yml` file.


## Backing up the data

When playing with friends I like to be extra safe and back up the minecraft world save data to some other drive. We can do 
this with the `run-backup.sh` script. This script will compress the `docker` folder in this repo to a `tar.gz` file and then 
move that tar file to the given destination path. 

I would recommend adding this as a `cron` job to make it easier.

```
crontab -e
```

Add the following line somewhere in there:

```
# Run the backup script at 4 AM and 4 PM (4, 16), putting the tar file in the given folder
0 4,16 * * * /path/to/base/minecraft/run-backup.sh -o /path/to/archive/minecraft/base-mc
```

## Access outside LAN

If you want to play with friends then you will need to port forward the `42071` port (or whatever you changed it to in the `docker-compose.yml` file) on your router.

Additionally, you will need some kind of dynamic DNS solution so that other people can get to your public facing IP address with ease. Personally I use
[No-Ip](https://www.noip.com/members/dns/) to do this because it is free, easy, and simple to use. 

Once you pick out a url from noip, then just have people join `foobar.hopto.org:42071` in Minecraft to play. 