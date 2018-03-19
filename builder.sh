#!/bin/sh

/usr/bin/pullsite.sh

cat /keys/userlist | users.sh

bash ssh_start ssh-server &

setcap 'cap_net_bind_service=+ep' /usr/bin/caddy

cd /srv; sudo -u www-data CADDYPATH="/caddyfolder" caddy -conf /etc/Caddyfile
#cd /srv; /bin/bash
