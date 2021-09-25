
#!/bin/sh
apt-get install tor -y
update-rc.d ssh defaults
service ssh start
if [ -f /var/lib/tor/hidden_service/hostname ]; then
	echo "Your hostname:"
	cat /var/lib/tor/hidden_service/hostname
else
	echo "Starting up Tor briefly to generate your hidden service hostname. Please wait..."
	service tor start & sleep 10; service tor stop ; echo "Your hostname:" ; cat /var/lib/tor/hidden_service/hostname
	echo "Regenerating server keys..."
	chmod +x /usr/local/bin/sshd-key-gen.sh ; /usr/local/bin/sshd-key-gen.sh
	rm /usr/local/bin/sshd-key-gen.sh
fi
update-rc.d tor defaults
service tor start
update-rc.d mariadb defaults
service mariadb start
update-rc.d apache2 defaults
service apache2 start
#sleep 1
#tail -f /var/log/tor/log
