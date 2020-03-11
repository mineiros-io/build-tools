FROM golang:1.14.0-alpine3.11

LABEL maintainer="The Mineiros.io Team <hello@mineiros.io>"

ENV TFLINT_VERSION=v0.15.1
ENV TERRAFORM_VERSION=0.12.23

# If TF_IN_AUTOMATION is set to any non-empty value, Terraform adjusts its output to avoid suggesting specific commands
# to run next. This can make the output more consistent and less confusing in workflows where users don't directly
# execute Terraform commands, like in CI systems or other wrapping applications.
ENV TF_IN_AUTOMATION="yes"

# Set Go flag so it won't require gcc https://github.com/golang/go/issues/26988
ENV CGO_ENABLED=0

# Install dependencies
RUN apk add --update bash git openssh openssl python3 && \
    pip3 install pre-commit

# Download terraform, verify checksum and install to bin dir
RUN wget \
    https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
    sed -i '/terraform_.*_linux_amd64.zip/!d' terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
    sha256sum -cs terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
    unzip terraform_${TERRAFORM_VERSION}_linussx_amd64.zip -d /usr/local/bin

# Download Tflint, verify checksum and install to bin dir
RUN wget \
    https://github.com/terraform-linters/tflint/releases/download/${TFLINT_VERSION}/tflint_linux_amd64.zip \
    https://github.com/terraform-linters/tflint/releases/download/${TFLINT_VERSION}/checksums.txt && \
    sed -i '/.*tflint_linux_amd64.zip/!d' checksums.txt && \
    sha256sum -cs checksums.txt && \
    unzip tflint_linux_amd64.zip -d /usr/local/bin

# Install golint and goimports that are being by some pre-commit hooks
RUN go get -u golang.org/x/lint/golint golang.org/x/tools/cmd/goimports

WORKDIR /app/src
