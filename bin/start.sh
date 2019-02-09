#!/usr/bin/env bash

TEST=""

DOCKER_START_COMMAND=""
DOCKER_STOP_COMMAND=""
COMPOSE_FILE=""
SERVICE_NAME=""
DOMAIN=""
EMAIL=""

confirm() {
	if [ "$1" == "" ]; then
		PROMPT="Are you sure? "
	else
		PROMPT="$1"
	fi
	read -r -p "${PROMPT} [y/N] " input
	case "$input" in
		[yY][eE][sS] | [yY])
			true
			;;
		*)
			false
			;;
	esac
} # confirm

# Function to validate input from the user as a valid email address.
validate_email() {
	EMAIL_REGEX="^[a-z0-9!#\$%&'*+/=?^_\`{|}~-]+(\.[a-z0-9!#$%&'*+/=?^_\`{|}~-]+)*@([a-z0-9]([a-z0-9-]*[a-z0-9])?\.)+[a-z0-9]([a-z0-9-]*[a-z0-9])?\$"
	if [ "$1" == "" ]; then
		email=""
	else
		email="$1"
	fi
	if [[ ${email} =~ ${EMAIL_REGEX} ]]; then
		true
	fi
	false
} # validate_email

# Function to validate input from the user as a valid domain name.
# TODO I don't think this works as I want it to, but....
validate_domain() {
	DOMAIN_REGEX="(?=^.{4,253}$)(^(?:[a-zA-Z0-9](?:(?:[a-zA-Z0-9\-]){0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,}$)"
	if [ "$1" == "" ]; then
		domain=""
	else
		domain="$1"
	fi
	if [[ ${domain} =~ ${DOMAIN_REGEX} ]]; then
		true
	fi
	false
} # validate_domain

create_env_file() {
	echo """
DOCKER_START_COMMAND=\"${DOCKER_START_COMMAND}\"
DOCKER_STOP_COMMAND=\"${DOCKER_STOP_COMMAND}\"
COMPOSE_FILE=\"${COMPOSE_FILE}\"
SERVICE_NAME=${SERVICE_NAME}
export DOMAIN=${DOMAIN}
export EMAIL=${EMAIL}
""" > .env
} # create_env_file

main() {
	# Check for the existence of a .env file. If it doesn't exist then take the
	# user through the prompts to create the environment. If it does, then just
	# use the configuration in the file to start the service for it's environment.
	if [ ! -f .env ]; then
		echo """
Hello, this script is used for starting a Traefik Service in a Docker Environment,
either using Docker Swarm Mode or just as a Docker Container. It is going to take
you through some prompts to make sure to use the properly configuration for your
environment and also set up some files for your Docker Service.
"""
		if confirm "Are you ready to start? "; then
			# Determine if use wants to run Docker Swarm Mode or Docker Containers.
			# Write to a file that this is Swarm Mode or Container environment.
			echo """
Awesome! Next, we will determine if you want to run this in Docker Swarm Mode
or as just a Docker Container. At any time during this, you can always Press
Ctrl-C to stop this script.
"""
			# Figure out if the user wants to run in Docker Swarm Mode or
			# Docker Containers.
			if confirm "Do you want to run this in Docker Swarm Mode? "; then
				COMPOSE_FILE="docker-compose.swarm.yml"
				read -r -p "What do you want to call your Docker Stack? " input
				DOCKER_START_COMMAND="docker stack deploy --compose-file ${COMPOSE_FILE} ${input}"
				DOCKER_STOP_COMMAND="docker stack rm ${input}"
			else
				COMPOSE_FILE="docker-compose.container.yml"
				DOCKER_START_COMMAND="docker-compose --file ${COMPOSE_FILE} up -d"
				read -r -p "What do you want to call your Docker Container? " input
				DOCKER_STOP_COMMAND="docker-compose --file ${COMPOSE_FILE} down"
			fi
			SERVICE_NAME="${input}"

			# Prompt the user for information to create their .env file.
			echo """
Okay, now we need to gather a little bit more information before we can start
the Traefik Docker Service.

First, we need to know your domain name. An example would be example.com. In order
for Traefik to work properly, you will need to make sure you have a DNS record
pointing your domain to the public IP address of the server that you are running
Traefik on. This setup also will have the Traefik Dashboard setup to run at
traefik.domain.tld, so make sure if you want the dashboard functionality to have
a DNS record for the subdomain traefik.domain.tld.
"""
			read -r -p "What is your domain name? " input
			while validate_domain ${input}; do
				read -r -p "Error: Invalid input: ${input} Please try again... " input
			done
			DOMAIN="${input}"

			read -r -p "What is your email address? " input
			while validate_email ${input}; do
				read -r -p "Error: Invalid input: ${input} Please try again... " input
			done
			EMAIL="${input}"

			create_env_file
		else
			exit 0
		fi # if confim
	fi # if .env

	# At this point, a .env file should be created.
	source .env

	# Check to make sure the acme.json file is already made.
	if [ ! -f ./traefik/acme.json ]; then
		( touch ./traefik/acme.json && chmod 600 ./traefik/acme.json )
	fi # if ./traefik/acme.json

	# Now make sure the log files are where they need to be for Traefik.
	touch ./traefik/logs/{access.log,traefik.log}

	if [ "${TEST}" == "True" ]; then
		echo "${DOCKER_START_COMMAND}"
	else
		eval "${DOCKER_START_COMMAND}"
	fi # if ${TEST}

	# EXIT_SUCCESS
	exit 0
} # main

main
