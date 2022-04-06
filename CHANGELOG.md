# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

- Upgrade Terraform to `v1.1.7`
- Upgrade TFLint to `v0.35.0`
- Upgrade Packer to `v1.8.0`
- Upgrade pre-commit to `v2.18.1`
- Upgrade golangci-lint to `v1.45.2`
- Upgrade checkov to `2.0.1037`

## [0.15.0]

### Fixed

- BREAKING CHANGE: remove broken tfswitch tool

### Changed

- Upgrade Terraform to `v1.1.4`

## [0.14.4]

### Fixed

- Run tfswitch before switching user

## [0.14.3]

### Changed

- Upgrade Terraform to `v1.1.2`
- Upgrade TFLint to `v0.34.1`
- Upgrade pre-commit to `v2.16.0`
- Upgrade checkov to `2.0.692`
- Upgrade snyk to `1.809.0`

## [0.14.2]

### Changed

- Upgrade Terraform to `v1.1.0`

## [0.14.1]

### Changed

- Upgrade Terraform to `v1.0.11`
- Upgrade TFLint to `v0.33.1`
- Upgrade Packer to `v1.7.8`
- Upgrade pre-commit to `v2.15.0`
- Upgrade golangci-lint to `v1.43.0`
- Upgrade checkov to `2.0.599`
- Upgrade snyk to `1.769.0`

## [0.14.0]

### Breaking Changes

- Remove `goimports`, `golint` and `revive` since those linters are handled
  through `golangci-lint` and therefore they are redundant.

## [0.13.0]

### Added

- Add [terraform-switcher](https://github.com/warrensbox/terraform-switcher)
  to allow for dynamically switching the Terraform version on container startup.
  To install and switch to a specific Terraform version using the `tfswitch`
  command, please set the `TF_VERSION` variable on docker run (e.g.
  `docker run -e TF_VERSION=1.0.3 --rm mineiros/build-tools:latest terraform --version`).
- Add revive for linting to replace the deprecated golint

### Changed

- Upgrade Terraform to `1.0.4`
- Upgrade Packer to `1.7.4`
- Upgrade TFLint to `0.30.0`
- Upgrade golangci-lint to `1.41.1`
- Upgrade checkov to `2.0.336`
- Upgrade snyk-cli to `1.669.0`

## [0.12.1]

### Changed

- Upgrade Terraform to `v1.0.2`

## [0.12.0]

### Changed

- Upgrade Terraform to `v1.0.0`
- Upgrade tflint to `v0.29.1`
- Upgrade packer to `v1.7.3`
- Upgrade pre-commit to `v2.13.0`
- Upgrade golangci-lint to `v1.41.0`
- Upgrade checkov to `v2.0.203`
- Upgrade snyk-cli to `v1.639.0`

## [0.11.0]

### Changed

- Upgrade golangci-lint to `v1.40.0`

## [0.11.0]

### Remove

- Remove volume definition in Dockerfile

### Added

- Add instructions on how to use named docker volumes

### Changed

- Install tools necessary for linters in separate steps
- Upgrade Terraform to `v0.15.3`

## [0.10.1]

### Changed

- Upgrade Terraform to `v0.15.2`

## [0.10.0]

### Changed

- Upgrade Terraform to `v0.15.1`

## [0.9.0]

### Added

- Configure `GOPATH` and `TF_DATA_DIR` and add both as docker volumes

### Changed

- Upgrade TfLint to v0.28.0
- Upgrade pre-commit to v2.12.1
- Upgrade snyk to v1.556.0

## [0.9.0]

### Changed

- Upgrade Terraform to v0.15.1
- Upgrade TfLint to v0.28.0
- Upgrade pre-commit to v2.12.1
- Upgrade snyk to v1.556.0

## [0.8.0]

### Added

- Add python3-dev to Dockerimage

### Changed

- Upgrade Checkov to v2.0.46
- Upgrade TfLint to v0.26.0
- Upgrade golangci-lint to v1.39.0
- Upgrade snyk to v1.541.0
- Upgrade Packer to v1.7.2
- Upgrade pre-commit to v2.12.0

## [0.7.2]

### Added

- Install Checkov v1.0.844

### Changed

- Upgrade Terraform to v0.14.7
- Upgrade Packer to v1.7.0
- Upgrade TfLint to v0.25.0
- Upgrade golangci-lint to v1.38.0
- Upgrade pre-commit to v2.11.1
- Upgrade snyk to v1.507.0

## [0.7.1]

### Changed

- migrated to github actions

## [0.7.0]

### Changed

- Upgrade Terraform to v0.14.1
- Upgrade Packer to v1.6.5
- Upgrade TfLint to v0.21.0
- Upgrade golangci-lint to v1.33.0
- Upgrade pre-commit to v2.9.3
- Upgrade Docker-base to fix security issues

## [0.6.3]

### Changed

- Upgrade Terraform to v0.13.4
- Upgrade Packer to v1.6.4
- Upgrade TfLint to v0.20.2

## [0.6.2]

### Changed

- Upgrade Terraform to v0.13.3
- Upgrade TfLint to v0.20.1.
- Upgrade golangci-lint to v1.31.0

## [0.6.1]

### Changed

- Upgrade Terraform to v0.13.2

## [0.6.0]

### Changed

- Add CHANGELOG.md that follows the keepachangelog standard.
- Upgrade golangci-lint to v1.30.0
- Upgrade TfLint to v0.19.1.
- Upgrade pre-commit to v2.7.1
- Upgrade Snyk-cli to v1.386.0
- Upgrade Terraform to v0.13.1

## [0.5.4]

### Changed

- Upgrade pre-commit-hooks to v0.1.4.
- Update logo and badges in README.md.

### Added

- Add phony-targets pre-commit hook.

## [0.5.3]

### Fix

- Fix some minor syntax issues in shellscript.

### Added

- Add shellcheck.
- Add markdown-link-check.
- Add golangci-lint.

### Changed

- Changed to new logo and change label color to new CD.

## [0.5.2]

### Added

- Add GNU make to docker image since it's required by our pre-commit-hooks.

## [0.5.1]

### Changed

- Upgrade Terraform to v0.12.26.

## [0.5.0]

### Fixed

- Fixes quoting in command-line arguments when invoking recursive bash -c or other commands.

## [0.4.0]

### Added

- Add possibility to run undera specific UID.
- Add possibility to run under SSH-Agent to access private repositories.

## [0.3.1]

### Fixed

- Fix broken release CI.ss

## [0.3.0]

### Added

- Simplify makefile variables.
- On repeated builds load container from cache.
- Check versions on builds.
- Add test to actually execute each build tool.
- Add NOCOLOR option ot make.
- Add pipefail to Makefile shell.

### Changed

- Update Terraform to v0.12.25.
- Update TFlint to v0.16.0.
- Update pre-commits 2.4.0.

## [0.2.2]

### Fixed

- Fix Ci to push correct latest tag to hub.docker.com.

## [0.2.1]

### Changed

- Update packer to v1.5.6.
- Refactor and fix Semaphore CI integration.

## [0.2.0]

### Changed

- Update the targets inside the makefile to match namespaces.
- Move filenames, path and urls to variables to avoid duplication.

## [0.1.6]

### Removed

- Remove docker from runlevel.
- Delete zip archives to compress the image.

### Added

- Add a script entrypoint.sh for dynamically setting options such as HOME on startup.

## [0.1.5]

### Added

- Allow adding additional tags for existing docker images.

## [0.1.4]

### Changed

- Upgrade golang from 1.14.2-alpine3.11.

## [0.1.3]

### Added

- Add snyk.io vulnerability scanner for detecting vulnerabilities in docker images.

## [0.1.2]

### Changed

- Upgrade Terraform to version 0.12.24.
- Upgrade Tflint to version 0.15.3.
- Upgrade Packer to version 1.5.5.

## [0.1.1]

### Added

- Add docker client as a dependency in order to use docker out of docker ( DooD ).

## [0.1.0]

### Added

- Add Packer to dependencies.

## [0.0.3]

### Changed

- Upgrade Terraform to v0.12.23.
- Upgrade TFLint to v0.15.1.

## [0.0.2]

### Changed

- Upgrade Terraform to 0.12.21.

## [0.0.1]

### Added

- Initial Release.
- Add first Makefile implementation with targets for Terraform and pre-commit.

<!-- References -->

[unreleased]: https://github.com/mineiros-io/build-tools/compare/v0.15.0...HEAD

[0.15.0]: https://github.com/mineiros-io/build-tools/compare/v0.14.4...v0.15.0
[0.14.4]: https://github.com/mineiros-io/build-tools/compare/v0.14.3...v0.14.4
[0.14.3]: https://github.com/mineiros-io/build-tools/compare/v0.14.2...v0.14.3
[0.14.2]: https://github.com/mineiros-io/build-tools/compare/v0.14.1...v0.14.2
[0.14.1]: https://github.com/mineiros-io/build-tools/compare/v0.14.0...v0.14.1
[0.14.0]: https://github.com/mineiros-io/build-tools/compare/v0.13.0...v0.14.0
[0.13.0]: https://github.com/mineiros-io/build-tools/compare/v0.12.1...v0.13.0
[0.12.0]: https://github.com/mineiros-io/build-tools/compare/v0.11.0...v0.12.0
[0.11.0]: https://github.com/mineiros-io/build-tools/compare/v0.10.1...v0.11.0
[0.10.1]: https://github.com/mineiros-io/build-tools/compare/v0.10.0...v0.10.1
[0.10.0]: https://github.com/mineiros-io/build-tools/compare/v0.9.0...v0.10.0
[0.9.0]: https://github.com/mineiros-io/build-tools/compare/v0.8.0...v0.9.0
[0.8.0]: https://github.com/mineiros-io/build-tools/compare/v0.7.2...v0.8.0
[0.7.2]: https://github.com/mineiros-io/build-tools/compare/v0.7.1...v0.7.2
[0.7.1]: https://github.com/mineiros-io/build-tools/compare/v0.7.0...v0.7.1
[0.7.0]: https://github.com/mineiros-io/build-tools/compare/v0.6.3...v0.7.0
[0.6.3]: https://github.com/mineiros-io/build-tools/compare/v0.6.2...v0.6.3
[0.6.2]: https://github.com/mineiros-io/build-tools/compare/v0.6.1...v0.6.2
[0.6.1]: https://github.com/mineiros-io/build-tools/compare/v0.6.0...v0.6.1
[0.6.0]: https://github.com/mineiros-io/build-tools/compare/v0.5.4...v0.6.0
[0.5.4]: https://github.com/mineiros-io/build-tools/compare/v0.5.3...v0.5.4
[0.5.3]: https://github.com/mineiros-io/build-tools/compare/v0.5.2...v0.5.3
[0.5.2]: https://github.com/mineiros-io/build-tools/compare/v0.5.1...v0.5.2
[0.5.1]: https://github.com/mineiros-io/build-tools/compare/v0.5.0...v0.5.1
[0.5.0]: https://github.com/mineiros-io/build-tools/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/mineiros-io/build-tools/compare/v0.3.1...v0.4.0
[0.3.1]: https://github.com/mineiros-io/build-tools/compare/v0.3.0...v0.3.1
[0.3.0]: https://github.com/mineiros-io/build-tools/compare/v0.2.2...v0.3.0
[0.2.2]: https://github.com/mineiros-io/build-tools/compare/v0.2.1...v0.2.2
[0.2.1]: https://github.com/mineiros-io/build-tools/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/mineiros-io/build-tools/compare/v0.1.6...v0.2.0
[0.1.6]: https://github.com/mineiros-io/build-tools/compare/v0.1.5...v0.1.6
[0.1.5]: https://github.com/mineiros-io/build-tools/compare/v0.1.4...v0.1.5
[0.1.4]: https://github.com/mineiros-io/build-tools/compare/v0.1.3...v0.1.4
[0.1.3]: https://github.com/mineiros-io/build-tools/compare/v0.1.2...v0.1.3
[0.1.2]: https://github.com/mineiros-io/build-tools/compare/v0.1.1...v0.1.2
[0.1.1]: https://github.com/mineiros-io/build-tools/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/mineiros-io/build-tools/compare/v0.0.3...v0.1.0
[0.0.3]: https://github.com/mineiros-io/build-tools/compare/v0.0.2...v0.0.3
[0.0.2]: https://github.com/mineiros-io/build-tools/compare/v0.0.1...v0.0.2
[0.0.1]: https://github.com/mineiros-io/build-tools/releases/tag/v0.0.1
