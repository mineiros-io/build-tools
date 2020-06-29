# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Changed
- Add CHANGELOG.md that follows the keepachangelog standard.
- Upgrade TfLint to v0.17.0.
- Upgrade pre-commit to v2.5.1
- Upgrade Snyk-cli to v1.349.0
- Upgrade Terraform to v0.12.28

## [0.5.4] - 2020-06-04
### Changed
- Upgrade pre-commit-hooks to v0.1.4.
- Update logo and badges in README.md.
### Added
- Add phony-targets pre-commit hook.

## [0.5.3] - 2020-05-30
### Fix
- Fix some minor syntax issues in shellscript.
### Added
- Add shellcheck.
- Add markdown-link-check.
- Add golangci-lint.
### Changed
- Changed to new logo and change label color to new CD.

## [0.5.2] - 2020-05-29
### Added
- Add GNU make to docker image since it's required by our pre-commit-hooks.

## [0.5.1] - 2020-05-29
### Changed
- Upgrade Terraform to v0.12.26.

## [0.5.0] - 2020-05-24
### Fixed
- Fixes quoting in command-line arguments when invoking recursive bash -c or other commands.

## [0.4.0] - 2020-05-21
### Added
- Add possibility to run undera specific UID.
- Add possibility to run under SSH-Agent to access private repositories.

## [0.3.1] - 2020-05-18
### Fixed
- Fix broken release CI.ss

## [0.3.0] - 2020-05-17
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

## [0.2.2] - 2020-05-16
### Fixed
- Fix Ci to push correct latest tag to hub.docker.com.

## [0.2.1] - 2020-05-16
### Changed
- Update packer to v1.5.6.
- Refactor and fix Semaphore CI integration.

## [0.2.0] - 2020-05-04
### Changed
- Update the targets inside the makefile to match namespaces.
- Move filenames, path and urls to variables to avoid duplication.

## [0.1.6] - 2020-05-03
### Removed
- Remove docker from runlevel.
- Delete zip archives to compress the image.
### Added
- Add a script entrypoint.sh for dynamically setting options such as HOME on startup.

## [0.1.5] - 2020-04-18
### Added
- Allow adding additional tags for existing docker images.

## [0.1.4] - 2020-04-17
### Changed
- Upgrade golang from 1.14.2-alpine3.11.

## [0.1.3] - 2020-04-10
### Added
- Add snyk.io vulnerability scanner for detecting vulnerabilities in docker images.

## [0.1.2] - 2020-03-27
### Changed
- Upgrade Terraform to version 0.12.24.
- Upgrade Tflint to version 0.15.3.
- Upgrade Packer to version 1.5.5.

## [0.1.1] - 2020-03-16
### Added
- Add docker client as a dependency in order to use docker out of docker ( DooD ).

## [0.1.0] - 2020-03-13
### Added
- Add Packer to dependencies.

## [0.0.3] - 2020-03-13
### Changed
- Upgrade Terraform to v0.12.23.
- Upgrade TFLint to v0.15.1.

## [0.0.2] - 2020-02-28
### Changed
- Upgrade Terraform to 0.12.21.

## [0.0.1] - 2020-05-25
### Added
- Initial Release.
- Add first Makefile implementation with targets for Terraform and pre-commit.

<!-- References -->
[Unreleased]: https://github.com/mineiros-io/build-tools/compare/v0.5.4...HEAD

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