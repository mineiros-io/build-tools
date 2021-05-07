[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>](https://mineiros.io/?ref=build-tools)

[![Build Status](https://mineiros.semaphoreci.com/badges/build-tools/branches/master.svg?style=shields)](https://mineiros.semaphoreci.com/projects/build-tools)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/mineiros-io/build-tools.svg?label=latest&sort=semver)](https://github.com/mineiros-io/build-tools/releases)
[![license](https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg)](https://opensource.org/licenses/Apache-2.0)
[<img src="https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack">](https://join.slack.com/t/mineiros-community/shared_invite/zt-ehidestg-aLGoIENLVs6tvwJ11w9WGg)

# build-tools

A collection of build tools for the Mineiros Infrastructure as Code (IaC) library.

- [Introduction](#introduction)
- [Getting started](#getting-started)
  - [Examples](#examples)
    - [Terraform init](#terraform-init)
    - [Work with S3 remote state](#work-with-s3-remote-state)
    - [Create a Terraform planfile](#create-a-terraform-planfile)
    - [Apply a Terraform planfile](#apply-a-terraform-planfile)
    - [Run go fmt on mounted source code](#run-go-fmt-on-mounted-source-code)
- [Module Versioning](#module-versioning)
  - [Backwards compatibility in `0.0.z` and `0.y.z` version](#backwards-compatibility-in-00z-and-0yz-version)
- [About Mineiros](#about-mineiros)
- [Reporting Issues](#reporting-issues)
- [Contributing](#contributing)
- [Makefile Targets](#makefile-targets)
- [License](#license)

## Introduction

The main part of **build-tools** is a docker image that comes with install
instructions for all necessary tools.
Currently, we are installing the following dependencies:

### Dependencies

- [Go](https://golang.org/)
- [Terraform](https://www.terraform.io/)
- [Packer](https://www.packer.io/)
- [Node.js & NPM](https://nodejs.org/)

### Linters

In addition to the above listed technologies, build-tools ships with some
pre-installed linters, that help you to ensure code quality and standards:

- [Golint](https://github.com/golang/lint)
- [golangci-lint](https://github.com/golangci/golangci-lint)
- [Goimports](https://godoc.org/golang.org/x/tools/cmd/goimports)
- [TFLint](https://github.com/terraform-linters/tflint)
- [markdown-link-check](https://github.com/tcort/markdown-link-check)

### Security

This repository ships with some pre-installed open-source software that
help you to monitor security:

- [Snyk](https://github.com/snyk/snyk)
- [Checkov](https://github.com/bridgecrewio/checkov)

## Getting started

The easiest way to use build-tools is to pull the image from
[hub.docker.com](https://hub.docker.com/r/mineiros/build-tools).

The following command will pull the image from the registry and runs
`terraform --version` inside a container.

```bash
docker run --rm \
  mineiros/build-tools:latest \
  terraform --version
```

### Working Directory

The containers working directory is `/build` which should be your target if
you decide to mount any files from your local filesystem.

### Terraform Working Directory

Per default Terraform is configured to use `/terraform` as its working
directory. This is configured through the `TF_DATA_DIR` environment variable
and means that the `.terraform` directory will be removed after
the container exits. We recommend creating a
[named docker volume](https://docs.docker.com/storage/volumes/) for the
`/terraform` directory to re-use its content between different runs.

```bash
docker run --rm \
  -v ${PWD}:/build \
  -v terraform-working-directory:/terraform
  mineiros/build-tools:latest \
  terraform init
```

The working directory can be adjusted for a specific container through the
`TF_DATA_DIR` environment variable.

```bash

docker run --rm \
  -v ${PWD}:/build \
  -e TF_DATA_DIR:/build
  mineiros/build-tools:latest \
  terraform init
```

### Go Working Directory

Per default, Go is configured to use `/go` as its working directory. This is
configured through the `GO_PATH` environment variable/ We recommend creating
a [named docker volume](https://docs.docker.com/storage/volumes/)
for the `/go` directory to re-use its content between 
different runs.

```bash
docker run --rm \
  -v ${PWD}:/build \
  -v go-path-directory:/go \
  mineiros/build-tools:latest \
  go test ./test/...
```

The Go directory can be adjusted for a specific container through the
`GO_PATH` environment variable.

```bash
docker run --rm \
  -e GO_PATH=/build \
  -v ${PWD}:/build \
  mineiros/build-tools:latest \
  go test ./test/...
```

### Examples

Please see the following examples for common use-cases.

#### Terraform init

Mount the current working diretory as a volume and run `terraform init` to
initialize the terraform working environment.

```bash
docker run --rm \
  -v ${PWD}:/build \
  mineiros/build-tools:latest \
  terraform init
```

#### Work with S3 remote state

Mount the current working directory as a volume, pass AWS access credentials as
environment variables and run `terraform init`. Requires
[S3](https://www.terraform.io/docs/backends/types/s3.html) to be configured as
the remote state backend.

```bash
docker run --rm \
  -v ${PWD}:/build \
  -e AWS_ACCESS_KEY_ID \
  -e AWS_SECRET_ACCESS_KEY \
  -e AWS_SESSION_TOKEN \
  mineiros/build-tools:latest \
  terraform init
```

#### Create a Terraform planfile

Mount the current working directory as a volume, pass AWS access credentials as
environment variables and run `terraform plan --out=plan.tf` for creating a
plan file that we can use with the `terraform apply` comand.

```bash
docker run --rm \
  -v ${PWD}:/build \
  -e AWS_ACCESS_KEY_ID \
  -e AWS_SECRET_ACCESS_KEY \
  -e AWS_SESSION_TOKEN \
  mineiros/build-tools:latest \
  terraform plan -input=false -out=plan.tf
```

#### Apply a Terraform planfile

Mount the current working directory as a volume, pass AWS access credentials as
environment variables and run
`terraform apply -auto-approve -input=false plan.tf` for applying changes.

```bash
docker run --rm \
  -v ${PWD}:/build \
  -e USER_UID=$(id -u) \
  -e AWS_ACCESS_KEY_ID \
  -e AWS_SECRET_ACCESS_KEY \
  -e AWS_SESSION_TOKEN \
  mineiros/build-tools:latest \
  terraform apply -input=false -out=plan.tf
```

#### Run go fmt on mounted source code

Mounts the current working director as a volume and run `go fmt` recursively.

```bash
docker run --rm \
  -v ${PWD}:/build \
  -e USER_UID=$(id -u) \
  mineiros/build-tools:latest \
  go fmt ./...
```

#### Run checkov on mounted directory
```bash
docker run --rm \                                                                                                                                                                                           
  -v ${PWD}:/build \
  -e USER_UID=$(id -u) \
  mineiros/build-tools:latest \
  checkov --directory ./
```

## Module Versioning

This Module follows the principles of [Semantic Versioning (SemVer)](https://semver.org/).

Using the given version number of `MAJOR.MINOR.PATCH`, we apply the following constructs:

1. Use the `MAJOR` version for incompatible changes.
1. Use the `MINOR` version when adding functionality in a backwards compatible manner.
1. Use the `PATCH` version when introducing backwards compatible bug fixes.

### Backwards compatibility in `0.0.z` and `0.y.z` version

- In the context of initial development, backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is
  increased. (Initial development)
- In the context of pre-release, backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is
  increased. (Pre-release)

## About Mineiros

Mineiros is a [DevOps as a Service](https://mineiros.io/?ref=build-tools) company based in Berlin, Germany. We offer commercial support
for all of our projects and encourage you to reach out if you have any questions or need help.
Feel free to send us an email at [hello@mineiros.io](mailto:hello@mineiros.io).

We can also help you with:

- Terraform modules for all types of infrastructure such as VPCs, Docker clusters, databases, logging and monitoring, CI, etc.
- Consulting & training on AWS, Terraform and DevOps

## Reporting Issues

We use GitHub [Issues](https://github.com/mineiros-io/build-tools/issues)
to track community reported issues and missing features.

## Contributing

Contributions are always encouraged and welcome! For the process of accepting changes, we use
[Pull Requests](https://github.com/mineiros-io/build-tools/pulls). If you'd like more information, please
see our [Contribution Guidelines](https://github.com/mineiros-io/build-tools/blob/master/CONTRIBUTING.md).

## Makefile Targets

This repository comes with a handy
[Makefile](https://github.com/mineiros-io/build-tools/blob/master/Makefile).
Run `make help` to see details on each available target.

## License

This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE](https://github.com/mineiros-io/build-tools/blob/master/LICENSE) for full details.

Copyright &copy; 2020 Mineiros GmbH
