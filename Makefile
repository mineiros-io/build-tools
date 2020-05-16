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

ifndef DOCKER_IMAGE_TAG
	DOCKER_IMAGE_TAG := latest
endif

ifndef DOCKER_SOCKET
	DOCKER_SOCKET := /var/run/docker.sock
endif

ifndef SNYK_MONITOR
	SNYK_MONITOR := true
endif

ifndef SNYK_CLI_DOCKER_IMAGE
	SNYK_CLI_DOCKER_IMAGE := snyk/snyk-cli:1.305.1-docker
endif

GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
RESET  := $(shell tput -Txterm sgr0)

.PHONY: default
default: help

.PHONY: docker/build
## Build the docker image
docker/build:
	docker build -t ${DOCKER_HUB_REPO}:${DOCKER_IMAGE_TAG} .

.PHONY: docker/tag
## Create a new tag
docker/tag:
	docker tag ${DOCKER_HUB_REPO}:${DOCKER_IMAGE_TAG} ${DOCKER_HUB_REPO}:latest

.PHONY: docker/save
## Save the docker image to disk
docker/save:
	docker save ${DOCKER_HUB_REPO}:${DOCKER_IMAGE_TAG} > "docker-image.tar"

.PHONY: docker/load
## Load saved image
docker/load:
	docker load < "docker-image.tar" | cat

.PHONY: docker/login
## Login to hub.docker.com ( requires the environment variables "DOCKER_HUB_USER" and "DOCKER_HUB_PASSWORD" to be set)
docker/login:
	@docker login -u ${DOCKER_HUB_USER} --password-stdin <<<"${DOCKER_HUB_PASSWORD}"

.PHONY: docker/push
## Push docker image to hub.docker.com
docker/push:
	if [ "${DOCKER_IMAGE_TAG:0:1}" == "v" ] ; then docker push ${DOCKER_HUB_REPO}:latest | cat ; fi
	docker push ${DOCKER_HUB_REPO}:${DOCKER_IMAGE_TAG} | cat

.PHONY: test/snyk
## Check for vulnerabilities with Snyk.io ( requires the environment variables "SNYK_TOKEN" and "USER_ID" to be set )
test/snyk:
	docker run --rm \
		-e SNYK_TOKEN \
		-e SNYK_USER_ID \
		-e "MONITOR=${SNYK_MONITOR}" \
		-v "${PWD}:/project" \
		-v ${DOCKER_SOCKET}:/var/run/docker.sock \
		${SNYK_CLI_DOCKER_IMAGE} test --docker ${DOCKER_HUB_REPO}:${DOCKER_IMAGE_TAG} --file=Dockerfile | cat

.PHONY: help
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
	{ lastLine = $$0 }' $(MAKEFILE_LIST)
