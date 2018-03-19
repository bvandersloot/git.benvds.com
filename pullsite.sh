#!/bin/bash
mkdir /var/www
mkdir /var/www/.ssh
mv /tmp/known_hosts /var/www/.ssh

cp /etc/ssh/ssh_host_ed25519_key.pub /var/www/.ssh/id_ed25519.pub
cp /etc/ssh/ssh_host_ed25519_key     /var/www/.ssh/id_ed25519

sudo chown -R www-data:www-data /var/www

#cd /var/www
#sudo -u www-data git clone https://github.com/bvandersloot/benvds.com.git
