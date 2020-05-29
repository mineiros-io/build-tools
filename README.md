<img src="https://raw.githubusercontent.com/mineiros-io/brand/master/mineiros-vertial-logo-smaller-font.svg" width="200"/>

[![Maintained by Mineiros.io](https://img.shields.io/badge/maintained%20by-mineiros.io-00607c.svg)](https://mineiros.io/?ref=build-tools)
[![Build Status](https://mineiros.semaphoreci.com/badges/build-tools/branches/master.svg?style=shields)](https://mineiros.semaphoreci.com/projects/build-tools)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/mineiros-io/build-tools.svg?label=latest&sort=semver)](https://github.com/mineiros-io/build-tools/releases)
[![License](https://img.shields.io/badge/License-Apache%202.0-brightgreen.svg)](https://opensource.org/licenses/Apache-2.0)

# build-tools

A collection of build tools for the Mineiros Infrastructure as Code (IaC) library.

## How to build the docker image

``` shell script
make docker/build
```

## Versioning

This Module follows the principles of [Semantic Versioning (SemVer)](https://semver.org/).
You can find each new release and it's changelog, in the
[Releases Page](https://github.com/mineiros-io/build-tools/releases).

Given a version number `MAJOR.MINOR.PATCH`, we increment the:
1) `MAJOR` version when we make incompatible changes,
2) `MINOR` version when we add functionality in a backwards compatible manner, and
3) `PATCH` version when we make backwards compatible bug fixes.

#### Backwards compatibility in `0.0.z` and `0.y.z` versions

- Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
- Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)

## Reporting issues

We use GitHub [Issues](https://github.com/mineiros-io/build-tools/issues) to track community reported issues.

## About Mineiros

Mineiros is a [DevOps as a Service](https://mineiros.io/) Company based in Berlin, Germany.
We offer Commercial Support for all of our projects, just send us an email to [hello@mineiros.io](mailto:hello@mineiros.io).

Our mission is it to simplify cloud infrastructure for developers. We provide a high quality Infrastructure as Code
(IaC) library, that helps you to automate and maintain complex cloud environments, so you can focus on what you do
best: build applications.

We can also help you with:
- Terraform Modules for all types of infrastructure such as VPC's, Docker clusters, databases, logging and monitoring,
  CI, etc.
- Complex Cloud- and Multi Cloud environments.
- Consulting & Training on AWS, Terraform and DevOps.

## Contribution

Contributions are very welcome! We use [Pull Requests](https://github.com/mineiros-io/build-tools/pulls)
for accepting changes.
Please see our [Contribution Guidelines](https://github.com/mineiros-io/build-tools/tree/master/CONTRIBUTING.md)
for full details.

## License

This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE](https://github.com/mineiros-io/build-tools/blob/master/LICENSE) for full details.

Copyright &copy; 2020 Mineiros
