#!/usr/bin/env make

# set required build variables if env variables aren't set yet
ifndef BUILD_VERSION
	BUILD_VERSION := latest
endif

ifndef REPOSITORY_NAME
	REPOSITORY_NAME := build-tools
endif

ifndef DOCKER_CACHE_IMAGE
	DOCKER_CACHE_IMAGE := ${REPOSITORY_NAME}-${BUILD_VERSION}.tar
endif

ifndef TERRAFORM_PLAN
	TERRAFORM_PLAN := tfplan
endif

#ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

# Run pre-commit hooks
docker-run-pre-commit-hooks:
	docker run --rm \
		mineiros/build-tools:latest \
		-v `pwd`:/app/src \
		sh -c "pre-commit install && pre-commit run --all-files"

# Run terraform plan
docker-run-terraform-plan:
	docker run --rm \
		-e AWS_ACCESS_KEY_ID \
		-e AWS_SECRET_ACCESS_KEY \
		-e GITHUB_TOKEN \
		-e GITHUB_ORGANIZATION \
		-v `pwd`:/app/src \
		mineiros/build-tools:latest \
		sh -c "terraform init -input=false && terraform plan -input=false"

# Run terraform apply
docker-run-terraform-apply:
	docker run --rm \
		-e AWS_ACCESS_KEY_ID \
		-e AWS_SECRET_ACCESS_KEY \
		-e GITHUB_TOKEN \
		-e GITHUB_ORGANIZATION \
		-v `pwd`:/app/src \
		mineiros/build-tools:latest \
		sh -c "terraform init -input=false && \
		terraform plan -out=${TERRAFORM_PLAN} -input=false &&  \
		terraform apply -input=false -auto-approve ${TERRAFORM_PLAN}"

.PHONY: docker-run-pre-commit-hooks docker-run-terraform-plan docker-run-terraform-apply
