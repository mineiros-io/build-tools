FROM golang:1.17.8-alpine3.14

LABEL maintainer="The Mineiros.io Team <hello@mineiros.io>"

# Configure directories and volumes
ENV BUILD_DIR=/build
ENV GOPATH=/go
ENV TF_DATA_DIR=/terraform

# https://www.terraform.io/
ARG TERRAFORM_VERSION
ARG TERRAFORM_ARCHIVE=terraform_${TERRAFORM_VERSION}_linux_amd64.zip
ARG TERRAFORM_URL=https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/${TERRAFORM_ARCHIVE}
ARG TERRAFORM_CHECKSUM=terraform_${TERRAFORM_VERSION}_SHA256SUMS
ARG TERRAFORM_CHECKSUM_URL=https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/${TERRAFORM_CHECKSUM}

# TFLint
# https://github.com/terraform-linters/tflint
ARG TFLINT_VERSION
ARG TFLINT_ARCHIVE=tflint_linux_amd64.zip
ARG TFLINT_URL=https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/${TFLINT_ARCHIVE}
ARG TFLINT_CHECKSUM=checksums.txt
ARG TFLINT_CHECKSUM_URL=https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/${TFLINT_CHECKSUM}

# Packer
# https://www.packer.io/
ARG PACKER_VERSION
ARG PACKER_ARCHIVE=packer_${PACKER_VERSION}_linux_amd64.zip
ARG PACKER_URL=https://releases.hashicorp.com/packer/${PACKER_VERSION}/${PACKER_ARCHIVE}
ARG PACKER_CHECKSUM=packer_${PACKER_VERSION}_SHA256SUMS
ARG PACKER_CHECKSUM_URL=https://releases.hashicorp.com/packer/${PACKER_VERSION}/${PACKER_CHECKSUM}

# pre-commit
# https://github.com/pre-commit/pre-commit
ARG PRECOMMIT_VERSION

# checkov
# https://github.com/bridgecrewio/checkov
ARG CHECKOV_VERSION

# golangci-lint https://github.com/golangci/golangci-lint
ARG GOLANGCI_LINT_VERSION
ARG GOLANGCI_LINT_URL=https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh

# If TF_IN_AUTOMATION is set to any non-empty value, Terraform adjusts its output to avoid suggesting specific commands
# to run next. This can make the output more consistent and less confusing in workflows where users don't directly
# execute Terraform commands, like in CI systems or other wrapping applications.
ENV TF_IN_AUTOMATION="yes"

# Set Go flag so it won't require gcc https://github.com/golang/go/issues/26988
ENV CGO_ENABLED=0

# Install dependencies
# We run Docker as Docker-out-of-Docker (DooD). DooD is a solution where you run the Docker CLI inside a container,
# and connect it to the host’s Docker by virtue of mount the /var/run/docker.sock into the container.
RUN apk upgrade musl
RUN apk add --no-cache \
    docker \
    bash \
    build-base \
    git \
    make \
    nodejs \
    npm \
    openrc \
    openssh \
    openssl \
    python3 \
    python3-dev \
    py3-pip \
    shellcheck

# Install pre-commit framework
RUN pip3 install --ignore-installed pre-commit==$PRECOMMIT_VERSION

# Install checkov
RUN pip3 install --ignore-installed checkov==$CHECKOV_VERSION

# Download Terraform, verify checksum and install to bin dir
RUN wget \
    $TERRAFORM_URL \
    $TERRAFORM_CHECKSUM_URL && \
    sed -i '/terraform_.*_linux_amd64.zip/!d' $TERRAFORM_CHECKSUM && \
    sha256sum -cs $TERRAFORM_CHECKSUM && \
    unzip $TERRAFORM_ARCHIVE -d /usr/local/bin && \
    rm -f $TERRAFORM_ARCHIVE $TERRAFORM_CHECKSUM

# Download Tflint, verify checksum and install to bin dir
RUN wget \
    $TFLINT_URL \
    $TFLINT_CHECKSUM_URL && \
    sed -i '/.*tflint_linux_amd64.zip/!d' $TFLINT_CHECKSUM && \
    sha256sum -cs $TFLINT_CHECKSUM && \
    unzip $TFLINT_ARCHIVE -d /usr/local/bin && \
    rm -f $TFLINT_ARCHIVE $TFLINT_CHECKSUM

# Install golangci-lint
# Golangci_lint suggests to install the binary through the install script rather than `go get`.
# For infos please see https://golangci-lint.run/usage/install/#ci-installation
RUN wget -O- -nv https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s "v$GOLANGCI_LINT_VERSION"

# Install markdown-lint-check
RUN npm install -g markdown-link-check

# Download Packer, verify checksum and install to bin dir
RUN wget \
    $PACKER_URL \
    $PACKER_CHECKSUM_URL && \
    sed -i '/packer_.*_linux_amd64.zip/!d' $PACKER_CHECKSUM && \
    sha256sum -cs $PACKER_CHECKSUM && \
    unzip $PACKER_ARCHIVE -d /usr/local/bin && \
    rm -f $PACKER_ARCHIVE $PACKER_CHECKSUM

COPY scripts/entrypoint.sh /

RUN install -m 0755 -d /root/.ssh
RUN ssh-keyscan -H github.com  >>/root/.ssh/known_hosts

WORKDIR ${BUILD_DIR}

ENTRYPOINT ["/entrypoint.sh"]

CMD ["echo", "You must call terraform, tflint or packer commands: e.g. `docker run mineiros/build-tools terraform --version`"]
