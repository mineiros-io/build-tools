# Set default shell to bash
SHELL := /bin/bash -o pipefail

ifdef CI
	V ?= 1
endif

TERRAFORM_VERSION = 0.13.1
TFLINT_VERSION = 0.19.1
PACKER_VERSION = 1.6.2
PRECOMMIT_VERSION = 2.7.1
GOLANGCI_LINT_VERSION = 1.30.0
SNYK_VERSION = 1.349.0

DOCKER_HUB_REPO ?= mineiros/build-tools
DOCKER_IMAGE_TAG ?= latest
DOCKER_IMAGE ?= ${DOCKER_HUB_REPO}:${DOCKER_IMAGE_TAG}
BUILD_IMAGE ?= ${DOCKER_HUB_REPO}:build

DOCKER_SOCKET ?= /var/run/docker.sock

SNYK_MONITOR ?= true
SNYK_CLI_DOCKER_IMAGE ?= snyk/snyk-cli:${SNYK_VERSION}-docker

CACHE_BASE_DIR ?= cache
CACHE_FILE ?= ${CACHE_BASE_DIR}/${DOCKER_HUB_REPO}/${DOCKER_IMAGE_TAG}.tar

ifndef NOCOLOR
	RED    := $(shell tput -Txterm setaf 1)
	GREEN  := $(shell tput -Txterm setaf 2)
	YELLOW := $(shell tput -Txterm setaf 3)
	RESET  := $(shell tput -Txterm sgr0)
endif

DOCKER_RUN_FLAGS += --rm
DOCKER_RUN_FLAGS += -v ${PWD}:/app/src
DOCKER_RUN_FLAGS += -e USER_UID=$(shell id -u)

DOCKER_FLAGS   += ${DOCKER_RUN_FLAGS}
DOCKER_RUN_CMD  = docker run ${DOCKER_FLAGS} ${BUILD_IMAGE}

.PHONY: default
default: help

## check for updates
.PHONY: check/updates
check/updates: PRECOMMIT_LATEST=$(shell curl -s "https://api.github.com/repos/pre-commit/pre-commit/releases/latest" | jq -r -M '.tag_name' | sed -e 's/^v//')
check/updates: TFLINT_LATEST=$(shell curl -s "https://api.github.com/repos/terraform-linters/tflint/releases/latest" | jq -r -M '.tag_name' | sed -e 's/^v//')
check/updates: GOLANGCI_LINT_LATEST=$(shell curl -s "https://api.github.com/repos/golangci/golangci-lint/releases/latest" | jq -r -M '.tag_name' | sed -e 's/^v//')
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
    
	@if [ "${GOLANGCI_LINT_VERSION}" != "${GOLANGCI_LINT_LATEST}" ] ; then \
	  echo "${RED}golangci-lint ${GOLANGCI_LINT_VERSION}${YELLOW} - update available to golangci-lint ${GOLANGCI_LINT_LATEST}${RESET}" ; \
	else \
	  echo "${GREEN}golangci-lint ${GOLANGCI_LINT_VERSION} - golangci-lint is up to date.${RESET}" ; \
	fi


	@if [ "${PRECOMMIT_VERSION}" != "${PRECOMMIT_LATEST}" ] ; then \
	  echo "${RED}pre-commit ${PRECOMMIT_VERSION}${YELLOW} - update available to pre-commit ${PRECOMMIT_LATEST}${RESET}" ; \
	else \
	  echo "${GREEN}pre-commit ${PRECOMMIT_VERSION} - pre-commit is up to date.${RESET}" ; \
	fi

## Build the docker image
.PHONY: docker/build
docker/build:
	docker build \
	  --build-arg TERRAFORM_VERSION=${TERRAFORM_VERSION} \
	  --build-arg PACKER_VERSION=${PACKER_VERSION} \
	  --build-arg TFLINT_VERSION=${TFLINT_VERSION} \
	  --build-arg PRECOMMIT_VERSION=${PRECOMMIT_VERSION} \
      --build-arg GOLANGCI_LINT_VERSION=${GOLANGCI_LINT_VERSION} \
	  -t ${BUILD_IMAGE} . | cat

## Create a new tag
.PHONY: docker/tag
docker/tag:
	docker tag ${BUILD_IMAGE} ${DOCKER_IMAGE}
	docker tag ${BUILD_IMAGE} ${DOCKER_HUB_REPO}:latest

## Login to hub.docker.com ( requires the environment variables "DOCKER_HUB_USER" and "DOCKER_HUB_PASSWORD" to be set)
.PHONY: docker/login
docker/login:
	@docker login -u ${DOCKER_HUB_USER} --password-stdin <<<"${DOCKER_HUB_PASSWORD}"

## Push docker image to hub.docker.com
.PHONY: docker/push
docker/push:
	if [[ "${DOCKER_IMAGE_TAG}" == v[0-9]* ]] ; then docker push ${DOCKER_HUB_REPO}:latest | cat ; fi
	docker push ${DOCKER_IMAGE} | cat

## Save the docker image to disk
.PHONY: docker/save
docker/save:
	mkdir -p $(shell dirname ${CACHE_FILE})
	docker save ${BUILD_IMAGE} > "${CACHE_FILE}"

## Load saved image
.PHONY: docker/load
docker/load:
	docker load < "${CACHE_FILE}" | cat

## Check for vulnerabilities with Snyk.io ( requires the environment variables "SNYK_TOKEN" and "USER_ID" to be set )
.PHONY: test/snyk
test/snyk:
	docker run --rm \
		-e SNYK_TOKEN \
		-e SNYK_USER_ID \
		-e "MONITOR=${SNYK_MONITOR}" \
		-v "${PWD}:/project" \
		-v ${DOCKER_SOCKET}:/var/run/docker.sock \
		${SNYK_CLI_DOCKER_IMAGE} test --docker ${BUILD_IMAGE} --file=Dockerfile | cat

## Run the pre-commit hooks inside build-tools docker
.PHONY: test/pre-commit
test/pre-commit:
	$(call docker-run,pre-commit run -a)

## Check if all build tools execute without issues
.PHONY: test/execute-tools
test/execute-tools:
	docker run --rm ${BUILD_IMAGE} terraform --version
	docker run --rm ${BUILD_IMAGE} packer --version
	docker run --rm ${BUILD_IMAGE} tflint --version
	docker run --rm ${BUILD_IMAGE} pre-commit --version
	docker run --rm ${BUILD_IMAGE} golint
	docker run --rm ${BUILD_IMAGE} goimports

## Display help for all targets
.PHONY: help
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

quiet-command = $(if ${V},${1},$(if ${2},@echo ${2} && ${1}, @${1}))
docker-run    = $(call quiet-command,${DOCKER_RUN_CMD} ${1} | cat,"${YELLOW}[DOCKER RUN] ${GREEN}${1}${RESET}")
