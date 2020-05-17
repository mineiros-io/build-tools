# Set default shell to bash
SHELL := /bin/bash

TERRAFORM_VERSION = 0.12.25
TFLINT_VERSION = 0.16.0
PACKER_VERSION = 1.5.6
PRECOMMIT_VERSION = 2.4.0

DOCKER_HUB_REPO ?= mineiros/build-tools
DOCKER_IMAGE_TAG ?= build
DOCKER_IMAGE ?= ${DOCKER_HUB_REPO}:${DOCKER_IMAGE_TAG}

DOCKER_SOCKET ?= /var/run/docker.sock

SNYK_MONITOR ?= true
SNYK_CLI_DOCKER_IMAGE ?= snyk/snyk-cli:1.305.1-docker

CACHE_BASE_DIR ?= cache
CACHE_FILE ?= ${CACHE_BASE_DIR}/${DOCKER_HUB_REPO}/${DOCKER_IMAGE_TAG}.tar

ifndef NOCOLOR
	RED    := $(shell tput -Txterm setaf 1)
	GREEN  := $(shell tput -Txterm setaf 2)
	YELLOW := $(shell tput -Txterm setaf 3)
	RESET  := $(shell tput -Txterm sgr0)
endif

.PHONY: default
default: help

.PHONY: check/updates

## check for updates
check/updates: PRECOMMIT_LATEST=$(shell curl -s "https://api.github.com/repos/pre-commit/pre-commit/releases/latest" | jq -r -M '.tag_name' | sed -e 's/^v//')
check/updates: TFLINT_LATEST=$(shell curl -s "https://api.github.com/repos/terraform-linters/tflint/releases/latest" | jq -r -M '.tag_name' | sed -e 's/^v//')
check/updates: PACKER_LATEST=$(shell curl -s https://checkpoint-api.hashicorp.com/v1/check/packer | jq -r -M '.current_version')
check/updates: TERRAFORM_LATEST = $(shell curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r -M '.current_version')
check/updates:
	@if [ "${TERRAFORM_VERSION}" != "${TERRAFORM_LATEST}" ] ; then \
	  echo "${RED}terraform ${TERRAFORM_VERSION}${YELLOW} - update available to terraform ${TERRAFORM_LATEST}${RESET}" ; \
	else \
	  echo "${GREEN}terraform ${TERRAFORM_VERSION} - terraform is up to date.${RESET}" ; \
	fi
	@if [ "${PACKER_VERSION}" != "${PACKER_LATEST}" ] ; then \
	  echo "${RED}packer ${PACKER_VERSION}${YELLOW} - update available to packer ${PACKER_LATEST}${RESET}" ; \
	else \
	  echo "${GREEN}packer ${PACKER_VERSION} - packer is up to date.${RESET}" ; \
	fi
	@if [ "${TFLINT_VERSION}" != "${TFLINT_LATEST}" ] ; then \
	  echo "${RED}tflint ${TFLINT_VERSION}${YELLOW} - update available to tflint ${TFLINT_LATEST}${RESET}" ; \
	else \
	  echo "${GREEN}tflint ${TFLINT_VERSION} - tflint is up to date.${RESET}" ; \
	fi
	@if [ "${PRECOMMIT_VERSION}" != "${PRECOMMIT_LATEST}" ] ; then \
	  echo "${RED}pre-commit ${PRECOMMIT_VERSION}${YELLOW} - update available to pre-commit ${PRECOMMIT_LATEST}${RESET}" ; \
	else \
	  echo "${GREEN}pre-commit ${PRECOMMIT_VERSION} - pre-commit is up to date.${RESET}" ; \
	fi

.PHONY: docker/build
## Build the docker image
docker/build:
	docker build \
	  --build-arg TERRAFORM_VERSION=${TERRAFORM_VERSION} \
	  --build-arg PACKER_VERSION=${PACKER_VERSION} \
	  --build-arg TFLINT_VERSION=${TFLINT_VERSION} \
	  --build-arg PRECOMMIT_VERSION=${PRECOMMIT_VERSION} \
	  -t ${DOCKER_IMAGE} . | cat

.PHONY: docker/tag
## Create a new tag
docker/tag:
	docker tag ${DOCKER_IMAGE} ${DOCKER_HUB_REPO}:latest

.PHONY: docker/login
## Login to hub.docker.com ( requires the environment variables "DOCKER_HUB_USER" and "DOCKER_HUB_PASSWORD" to be set)
docker/login:
	@docker login -u ${DOCKER_HUB_USER} --password-stdin <<<"${DOCKER_HUB_PASSWORD}"

.PHONY: docker/push
## Push docker image to hub.docker.com
docker/push:
	if [[ "${DOCKER_IMAGE_TAG}" == v[0-9]* ]] ; then docker push ${DOCKER_HUB_REPO}:latest | cat ; fi
	docker push ${DOCKER_IMAGE} | cat

.PHONY: docker/save
## Save the docker image to disk
docker/save:
	mkdir -p $(shell dirname ${CACHE_FILE})
	docker save ${DOCKER_IMAGE} > "${CACHE_FILE}"

.PHONY: docker/load
## Load saved image
docker/load:
	docker load < "${CACHE_FILE}" | cat

.PHONY: test/snyk
## Check for vulnerabilities with Snyk.io ( requires the environment variables "SNYK_TOKEN" and "USER_ID" to be set )
test/snyk:
	docker run --rm \
		-e SNYK_TOKEN \
		-e SNYK_USER_ID \
		-e "MONITOR=${SNYK_MONITOR}" \
		-v "${PWD}:/project" \
		-v ${DOCKER_SOCKET}:/var/run/docker.sock \
		${SNYK_CLI_DOCKER_IMAGE} test --docker ${DOCKER_IMAGE} --file=Dockerfile | cat

.PHONY: test/snyk
## Check if all build tools execute without issues
test/execute-tools:
	docker run --rm ${DOCKER_IMAGE} terraform --version
	docker run --rm ${DOCKER_IMAGE} packer --version
	docker run --rm ${DOCKER_IMAGE} tflint --version
	docker run --rm ${DOCKER_IMAGE} pre-commit --version
	docker run --rm ${DOCKER_IMAGE} golint
	docker run --rm ${DOCKER_IMAGE} goimports

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
				printf "  ${GREEN}make %-20s${RESET} %s\n", cmd, msg; \
			} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)
