#!/bin/bash

if [ -n "${TF_VERSION}" ]; then
  echo "setting TF_VERSION is no longer supported"
  exit 1
fi

if [ -n "${USER_UID}" ]; then
  adduser -u "${USER_UID}" --shell /bin/bash -D user
  install -m 700 -o user -g user -d /home/user/.ssh
  install -m 600 -o user -g user /root/.ssh/known_hosts /home/user/.ssh

  exec su user -c "${*@Q}"
fi

exec "${@}"
