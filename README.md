# docker-traefik

This repository is a demonstration on how to setup Traefik as just a basic container service or in
Docker Swarm Mode.

## What is Traefik?

A reverse proxy / load balancer that's easy, dynamic, automatic, fast, full-featured, open source, production proven, provides metrics, and integrates with every major cluster technology... No wonder it's so popular!

> <a href="https://traefik.io/">Traefik</a>

## How to use this repository

First you will need to clone the repository locally:

```bash
$ git clone https://github.com/BashfulBandit/docker-traefik.git
```

Now depending on your usage, see the appropriate section below.

### Docker Containers

### Docker Swarm Mode

First, some things you need to consider when running in Docker Swarm Mode. The docker-compose.yml
file will mount a host directory to the container directory to presever logs and the acme certificates
between container starts and stops. To achieve this in Docker Swarm Mode, you will want to have a way
to have the host directory be the same across all the Docker Nodes. I personally use NFS mounts to achieve this, but there are other ways. This is just mine.


Once you have a Docker Swarm setup with common directory across all Docker Nodes and have cloned the repository locally. You will need to change into the swarm directory in the repository.

```bash
$ cd docker-traefik/swarm
```

Now you will need to create your own version of .env file and initialize the variables to your environment. See Environment Variables section below for details.

```bash
$ cp .env-example .env
$ <insert favorite text editor a.k.a vim> .env
```

Once you have setup your .env file with the your environments information, you can start the service.
I have provided a simple script to do the rest of the setup for you.

```bash
$ bash bin/start.sh
```

After a little bit, you should be able to access your Traefik Dashboard using HTTPS via traefik.${DOMAIN}. Assuming you have the subdomain setup to send requests to your IP.

## Environment Variables

### `PROXY_DOCKER_NETWORK`

This is the name of the Docker Network that will be created. You will need to use this same Docker Network name for services you create behind Traefik for it to be able to communicate with them properly.

### `DOMAIN`

The name of your domain you want Traefik to proxy for. For this use case, it is just being used for the Dashboard service of Traefik itself at traefik.$DOMAIN. This requires your DNS be set up to send traefik.$DOMAIN to your IP address.

### `EMAIL`

The email address used for the ACME Challenge.

### `USERNAME`

This is used for securing your Traefik Dashboard service. When you go to traefik.$DOMAIN, it will prompt you for a username and password.

### `PASSWORD`

This is used for securing your Traefik Dashboard service. When you go to traefik.$DOMAIN, it will prompt you for a username and password.
