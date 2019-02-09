#!/usr/bin/env bash

TEST=""

# TODO Need to save SERVICE_NAME and COMPOSE_FILE to .env file or some other file.
if [ ! -f .env ]; then
	echo "The .env file seems to be missing. This script depends on that file."
	exit 1
else
	source .env
fi

if [ "${TEST}" == "True" ]; then
	echo "${DOCKER_STOP_COMMAND}"
else
	eval "${DOCKER_STOP_COMMAND}"
fi

exit 0
