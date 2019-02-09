#!/usr/bin/env bash

TEST=""

# Check to make sure the .env file exists. This file does two things for this script.
# 1. Tells the script that the start.sh script has been run or someone manually
# 	set up their .env file, which is okay as well.
# 2. Defines some variables for this script and Docker.
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

# EXIT_SUCCESS
exit 0
