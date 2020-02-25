# Set default shell to bash
SHELL := /bin/bash

BUILD_TOOLS_DOCKER_REPO = mineiros/build-tools

# Set default value for environment variable if there aren't set already
ifndef BUILD_TOOLS_VERSION
	BUILD_TOOLS_VERSION := latest
endif

ifndef BUILD_TOOLS_DOCKER_IMAGE
	BUILD_TOOLS_DOCKER_IMAGE := ${BUILD_TOOLS_DOCKER_REPO}:${BUILD_TOOLS_VERSION}
endif

ifndef DOCKER_HUB_REPO
	DOCKER_HUB_REPO := mineiros/build-tools
endif

ifndef DOCKER_IMAGE_VERSION
	DOCKER_IMAGE_VERSION := latest
endif

ifndef DOCKER_IMAGE_TAG
	DOCKER_IMAGE_TAG := latest
endif

GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
RESET  := $(shell tput -Txterm sgr0)

## Display help for all targets
help:
	@awk '/^[a-zA-Z_0-9%:\\\/-]+:/ { \
		msg = match(lastLine, /^## (.*)/); \
			if (msg) { \
				cmd = $$1; \
				msg = substr(lastLine, RSTART + 3, RLENGTH); \
				gsub("\\\\", "", cmd); \
				gsub(":+$$", "", cmd); \
				printf "  \x1b[32;01m%-35s\x1b[0m %s\n", cmd, msg; \
			} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST) | sort -u

## Build the docker image
docker/build:
	docker build -t ${DOCKER_HUB_REPO}:latest -t ${DOCKER_HUB_REPO}:${DOCKER_IMAGE_VERSION} .

## Create a new tag ( expects the "DOCKER_IMAGE_TAG" environment variable to be set )
docker/tag:
	docker tag ${DOCKER_HUB_REPO}:${DOCKER_IMAGE_VERSION} ${DOCKER_HUB_REPO}:${DOCKER_IMAGE_TAG}

## Save the docker image to disk
docker/save:
	docker save ${DOCKER_HUB_REPO}:${DOCKER_IMAGE_VERSION} > "${DOCKER_IMAGE_VERSION}.tar"

## Load saved image
docker/load:
	docker load < "${DOCKER_IMAGE_VERSION}.tar"

## Login to hub.docker.com ( requires the environment variables "DOCKER_HUB_USER" and "DOCKER_HUB_PASSWORD" to be set)
docker/login:
	@echo ${DOCKER_HUB_PASSWORD} | docker login -u ${DOCKER_HUB_USER} --password-stdin

## Push docker image to hub.docker.com
docker/push:
	docker push ${DOCKER_HUB_REPO}
