#!/bin/bash
/usr/local/bin/openvpn2 --config /usr/local/bin/client2.conf &	
while true
do
	sleep 180 
	ping 172.16.58.1 -i 10 -c 1 >/dev/null 2>&1
	VPN_CONNECT=$?
	if [ "$VPN_CONNECT" != "0" ];
	then
		echo "reconnect"
		killall -9 openvpn2
		sleep 3
		/usr/local/bin/openvpn2 --config /usr/local/bin/client2.conf &	
	else 
		echo "ok"
	fi
done
