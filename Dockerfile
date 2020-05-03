FROM golang:1.14.2-alpine3.11

LABEL maintainer="The Mineiros.io Team <hello@mineiros.io>"

ENV TERRAFORM_VERSION=0.12.24
ENV TFLINT_VERSION=v0.15.3
ENV PACKER_VERSION=1.5.5

# If TF_IN_AUTOMATION is set to any non-empty value, Terraform adjusts its output to avoid suggesting specific commands
# to run next. This can make the output more consistent and less confusing in workflows where users don't directly
# execute Terraform commands, like in CI systems or other wrapping applications.
ENV TF_IN_AUTOMATION="yes"

# Set Go flag so it won't require gcc https://github.com/golang/go/issues/26988
ENV CGO_ENABLED=0

# Install dependencies
#
# We run Docker as Docker-out-of-Docker (DooD). DooD is a solution where you run the Docker CLI inside a container,
# and connect it to the host’s Docker by virtue of mount the /var/run/docker.sock into the container.
RUN apk add --update docker bash git openrc openssh openssl python3

# Install pre-commit framework
RUN pip3 install pre-commit

# Download terraform, verify checksum and install to bin dir
RUN wget \
    https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
    sed -i '/terraform_.*_linux_amd64.zip/!d' terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
    sha256sum -cs terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin && \
    rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip terraform_${TERRAFORM_VERSION}_SHA256SUMS

# Download Tflint, verify checksum and install to bin dir
RUN wget \
    https://github.com/terraform-linters/tflint/releases/download/${TFLINT_VERSION}/tflint_linux_amd64.zip \
    https://github.com/terraform-linters/tflint/releases/download/${TFLINT_VERSION}/checksums.txt && \
    sed -i '/.*tflint_linux_amd64.zip/!d' checksums.txt && \
    sha256sum -cs checksums.txt && \
    unzip tflint_linux_amd64.zip -d /usr/local/bin && \
    rm -f tflint_linux_amd64.zip checksums.txt

# Install golint and goimports that are being by some pre-commit hooks
RUN go get -u golang.org/x/lint/golint golang.org/x/tools/cmd/goimports

# Download Packer, verify checksum and install to bin dir
RUN wget \
    https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip \
    https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_SHA256SUMS && \
    sed -i '/packer_.*_linux_amd64.zip/!d' packer_${PACKER_VERSION}_SHA256SUMS && \
    sha256sum -cs packer_${PACKER_VERSION}_SHA256SUMS && \
    unzip packer_${PACKER_VERSION}_linux_amd64.zip -d /usr/local/bin && \
    rm -f packer_${PACKER_VERSION}_linux_amd64.zip packer_${PACKER_VERSION}_SHA256SUMS


COPY scripts/entrypoint.sh /

WORKDIR /app/src

ENTRYPOINT ["/entrypoint.sh"]

CMD ["echo", "You must call terraform, tflint or packer  commands: e.g. `docker run mineiros/build-tools terraform --version`"]
