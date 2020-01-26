#!/bin/bash
export BUILD_TOOLS_ORG=${1:-mineiros-io}
export BUILD_TOOLS_PROJECT=${2:-build-tools}
export BUILD_TOOLS_BRANCH=${3:-master}
export GITHUB_REPO="https://github.com/${BUILD_TOOLS_ORG}/${BUILD_TOOLS_PROJECT}.git"

if [ "$BUILD_TOOLS_PROJECT" ] && [ -d "$BUILD_TOOLS_PROJECT" ]; then
  echo "Removing existing $BUILD_TOOLS_PROJECT"
  rm -rf "$BUILD_TOOLS_PROJECT"
fi

echo "Cloning ${GITHUB_REPO}#${BUILD_TOOLS_BRANCH}..."
git clone -b $BUILD_TOOLS_BRANCH $GITHUB_REPO
