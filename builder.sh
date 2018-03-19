#!/bin/sh

cat /keys/userlist | users.sh

bash ssh_start ssh-server &

cd /srv; caddy -conf /etc/Caddyfile
#cd /srv; /bin/bash
