#!/bin/sh

echo "Completed build"

cd /srv; caddy -conf /etc/Caddyfile
#cd /srv; /bin/bash 
