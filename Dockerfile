FROM golang:1.13.5-alpine3.11

LABEL maintainer="The Mineiros.io Team <hello@mineiros.io>"

ENV TFLINT_VERSION=v0.13.4
ENV TERRAFORM_VERSION=0.12.20

# Set Go flag so it won't require gcc https://github.com/golang/go/issues/26988
ENV CGO_ENABLED=0

# Install dependencies
RUN apk add --update bash git openssh openssl python3 && \
    pip3 install pre-commit

# Download terraform
RUN wget \
    https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS

# Verify the checksum
RUN sed -i '/terraform_.*_linux_amd64.zip/!d' terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
    sha256sum -cs terraform_${TERRAFORM_VERSION}_SHA256SUMS

# Unzip and move to bin directory
RUN unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin

# Download Tflint
RUN wget \
    https://github.com/terraform-linters/tflint/releases/download/${TFLINT_VERSION}/tflint_linux_amd64.zip \
    https://github.com/terraform-linters/tflint/releases/download/${TFLINT_VERSION}/checksums.txt

# Verify the checksum
RUN sed -i '/.*tflint_linux_amd64.zip/!d' checksums.txt && \
    sha256sum -cs checksums.txt

# Unzip and move to bin directory
RUN unzip tflint_linux_amd64.zip -d /usr/local/bin

WORKDIR /app/src

# Copy sources
#COPY . .

# Install pre-commit hooks
#RUN pre-commit install

#RUN addgroup --gid "$GID" "$USER" \
#    && adduser \
#    --disabled-password \
#    --gecos "" \
#    --home "$(pwd)" \
#    --ingroup "$USER" \
#    --no-create-home \
#    --uid "$UID" \
#    "$USER"
# USER $USER
