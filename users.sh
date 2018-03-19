#!/bin/bash

while read -r line; 
do
	#echo $line 
	arr=( $(echo $line | tr " " "\n"))
	user=${arr[0]}
	uid=${arr[1]}
	key=${arr[2]}
	groups=$(echo ${arr[3]} | tr "," "\n")

	adduser --gecos ",,," --home /home/$user --uid $uid --disabled-password $user
	mkdir /home/$user/.ssh && chmod 700 /home/$user/.ssh
	touch /home/$user/.ssh/authorized_keys && chmod 600 /home/$user/.ssh/authorized_keys
	cp /tmp/README.user /home/$user/README
	ln -s /srv /home/$user/git
	chown -R $user:$user /home/$user
	
	cat /keys/$key >> /home/$user/.ssh/authorized_keys

	echo "---"
	echo "$user"
	echo "---"
	echo "$uid"
	echo "---"
	echo "$key"
	echo "---"
	for g in $groups
	do
		echo "++"
		echo "$g"
		echo "++"
	done
	echo "---"
done
