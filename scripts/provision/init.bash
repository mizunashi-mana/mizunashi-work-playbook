#!/usr/bin/env bash

set -euxo pipefail

if [ "$WORKUSER" = '' ] || [ "$SSH_PORT" = '' ] || [ "$SSH_AUTHORIZED_KEY" = '' ]; then
  echo "Require envs missing: WORKUSER=working username, SSH_PORT=The listen port of SSHd, SSH_AUTHORIZED_KEY=ssh key to provision"
  exit 1
fi

apt-get update -y
apt-get install -y sudo python3

gpasswd --add "$WORKUSER" sudo

tee /etc/ssh/sshd_config.d/server.conf <<EOS
Port $SSH_PORT
EOS

WORKUSER_HOMEDIR="$(eval echo ~"$WORKUSER")"

if ! [ -d "$WORKUSER_HOMEDIR/.ssh" ]; then
  mkdir -p "$WORKUSER_HOMEDIR/.ssh"
  chown "$WORKUSER:$WORKUSER" "$WORKUSER_HOMEDIR/.ssh"
fi

if ! [ -e "$WORKUSER_HOMEDIR/.ssh/authorized_keys" ]; then
  touch "$WORKUSER_HOMEDIR/.ssh/authorized_keys"
  chown "$WORKUSER:$WORKUSER" "$WORKUSER_HOMEDIR/.ssh/authorized_keys"
  chmod 0600 "$WORKUSER_HOMEDIR/.ssh/authorized_keys"
fi
if ! grep "$SSH_AUTHORIZED_KEY" "$WORKUSER_HOMEDIR/.ssh/authorized_keys"; then
  echo "$SSH_AUTHORIZED_KEY" | tee --append "$WORKUSER_HOMEDIR/.ssh/authorized_keys"
fi
