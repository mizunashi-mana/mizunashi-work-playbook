#!/usr/bin/env bash

set -euxo pipefail

if [ "$WORKUSER" = '' ] || [ "$SSH_PORT" = '' ]; then
  echo "Require envs missing: $WORKUSER=working username, $SSH_PORT=The listen port of SSHd"
  exit 1
fi

apt-get update -y
apt-get install -y sudo
gpasswd --add "$WORKUSER" sudo

tee /etc/ssh/sshd_config.d/server.conf <<EOS
Port $SSH_PORT
EOS

WORKUSER_HOMEDIR="$(eval echo ~"$WORKUSER")"

if ! [ -d "$WORKUSER_HOMEDIR/.ssh" ]; then
  mkdir -p "$WORKUSER_HOMEDIR/.ssh"
  chown "$WORKUSER:$WORKUSER" "$WORKUSER_HOMEDIR/.ssh"
fi

SSH_AUTHORIZED_KEY='ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMkqfF4qMFhr2fg+Yw3WLIqaRLqYzkCjWy2fdF4eQ5LG mizunashi-work-playbook'
if ! [ -e "$WORKUSER_HOMEDIR/.ssh/authorized_keys" ]; then
  touch "$WORKUSER_HOMEDIR/.ssh/authorized_keys"
  chown "$WORKUSER:$WORKUSER" "$WORKUSER_HOMEDIR/.ssh/authorized_keys"
  chmod 0600 "$WORKUSER_HOMEDIR/.ssh/authorized_keys"
fi
if ! grep "$SSH_AUTHORIZED_KEY" "$WORKUSER_HOMEDIR/.ssh/authorized_keys"; then
  echo "$SSH_AUTHORIZED_KEY" | tee --append "$WORKUSER_HOMEDIR/.ssh/authorized_keys"
fi
