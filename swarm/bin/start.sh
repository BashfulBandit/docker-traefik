#!/usr/bin/env bash

CONFIG=".env"

if [ ! -f ${CONFIG} ]; then
	echo """
The ${CONFIG} file seems to be missing. Make sure you make your own ${CONFIG} file.
See the example-${CONFIG} file to make your own.
"""
	exit 1
else
	source ${CONFIG}
fi

# First, make sure acme.json file is created and with the proper permissions.
if [ ! -f ./traefik/acme.json ]; then
	( cd ./traefik && touch acme.json && chmod 600 acme.json )
fi

# Second, make log files.
touch ./traefik/logs/{access.log,traefik.log}

# Start the docker stack in Docker Swarm mode.
docker stack deploy --compose-file docker-compose.yml traefik
