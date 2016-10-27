#!/bin/sh

if [ -z "$AUTHORIZED_KEYS" ]; then
  echo "You must provide the environment variable AUTHORIZED_KEYS"
  exit 1
fi

echo "Creating /root/.ssh/authorized_keys file..."

mkdir -p /root/.ssh
echo "$AUTHORIZED_KEYS" > /root/.ssh/authorized_keys

/usr/sbin/sshd -D