#!/bin/bash

if [ -n "${TF_VERSION}" ]; then
  tfswitch "${TF_VERSION}"
fi

if [ -n "${USER_UID}" ]; then
  adduser -u "${USER_UID}" --shell /bin/bash -D user
  install -m 700 -o user -g user -d /home/user/.ssh
  install -m 600 -o user -g user /root/.ssh/known_hosts /home/user/.ssh

  exec su user -c "${*@Q}"
fi

exec "${@}"
