# docker-traefik

This repository is a demonstration on how to setup Traefik as just a basic container service or in
Docker Swarm Mode to automate HTTPS via Let's Encrypt. There are a number of other configurations you can do with this, but I tried to keep this simple. For other configuration options, take a look at [Traefik's Documentation](https://docs.traefik.io/).

## What is Traefik?

A reverse proxy / load balancer that's easy, dynamic, automatic, fast, full-featured, open source, production proven, provides metrics, and integrates with every major cluster technology... No wonder it's so popular!

> <a href="https://traefik.io/">Traefik</a>

## How to use this repository

First, you will need to clone the repository locally:

```bash
$ git clone https://github.com/BashfulBandit/docker-traefik.git
```

Now you will just need to run the start.sh BASH script.

```bash
$ bash bin/start.sh
```

This will take you through the process of determining if you are wanting to run this in Docker Swarm Mode or just as a single Docker Container.
It will also set up the proper environment variables for you and store them in the .env file. See [Environment Variables](#environment-variables) section for me details.

## How to stop the service?

If you have previous run the start.sh script, you can easily stop everything by running the command below.

```bash
$ bash bin/stop.sh
```

## How to setup another service behind your Traefik Docker Service.

If you want to setup a Docker service behind Traefik, which I am assuming that is your main goal for setting this up. You will need to configure the docker-compose file or your docker run script for the service to have Traefik recognize it.
There are two main requirements for Traefik to be able to recognize the service and to be able to communicate with the service.

* The Docker Service will need to be a part of the same Docker Network Traefik is a part of. The easiest way to do this is by attaching your Docker Service to the 'proxy-net' Docker Network made for Traefik. This can be done a number of different ways. See the example directory in this repository for one way.
* The Docker Service will need some labels defined for Traefik to know how to handle requests to this service. Here are the main labels needed. See the example directory in this repository for an example.
	* traefik.frontend.rule
	* traefik.docker.network
	* traefik.port
	* traefik.enable

## Environment Variables

All these environment variables will be configured the first time you run the start.sh script, but you can manually configure them in your .env file.

### `DOCKER_START_COMMAND`

This is the command used to start the Traefik Docker Service.

### `DOCKER_STOP_COMMAND`

This is the command used to stop the Traefik Docker Service.

### `COMPOSE_FILE`

This is the compose file used when starting and stopping your Traefik Docker Service.

### `SERVICE_NAME`

This is either the name of your Docker Swarm Stack or the Docker Container based on what environment you are running.

### `DOMAIN`

The name of your domain you want Traefik to proxy for. For this use case, it is just being used for the Dashboard service of Traefik itself at traefik.$DOMAIN. This requires your DNS be set up to send traefik.$DOMAIN to your IP address.

### `EMAIL`

The email address used for the ACME Challenge.

## Report an Issue

If you have any issues with this repository and it's functionality, check out if there is already a GitHub issue submitted and if not, feel free to submit one [here](https://github.com/BashfulBandit/docker-traefik/issues).

## Resources

* [Docker](https://www.docker.com/) - a computer program that performs operating-system-level virtualization, also known as "containerization".
* [Traefik](https://traefik.io/) - a reverse proxy / load balancer that's easy, dynamic, automatic, fast, full-featured, open source, production proven, provides metrics, and integrates with every major cluster technology.
* [Let's Encrypt](https://letsencrypt.org/) - a certificate authority that provides X.509 certificates for Transport Layer Security (TLS) encryption at no charge.
