#!/bin/bash
while true
do
	sleep 180 
	ping 172.16.56.1 -i 10 -c 1 >/dev/null 2>&1
	VPN_CONNECT=$?
	if [ "$VPN_CONNECT" != "0" ];
	then
		echo "reconnect"
		service openvpn restart
	else 
		echo "ok"
	fi
done
