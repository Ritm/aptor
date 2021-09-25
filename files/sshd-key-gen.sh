#!/bin/sh
SSHKEYGEN=/usr/bin/ssh-keygen

$SSHKEYGEN -q -t rsa  -f /etc/ssh/ssh_host_rsa_key -N "" \
-C "" < /dev/null > /dev/null 2> /dev/null
echo "Created /etc/ssh_host_rsa_key"

$SSHKEYGEN -q -t dsa  -f /etc/ssh/ssh_host_dsa_key -N "" \
-C "" < /dev/null > /dev/null 2> /dev/null
echo "Created /etc/ssh_host_dsa_key"

exit 0
