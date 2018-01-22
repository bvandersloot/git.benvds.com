#!/bin/sh

cat /keys/userlist | users.sh

systemctl start ssh

#cd /srv; caddy -conf /etc/Caddyfile
cd /srv; /bin/bash 
