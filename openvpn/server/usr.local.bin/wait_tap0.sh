while true
do
	ifconfig| grep tap0 >/dev/null
	TAP_ON=$?
	ifconfig|grep br0 >/dev/null
	BR_ON=$?
	if [ "$TAP_ON" == "0" ] && [ "$BR_ON" != "0" ];
	then
		echo DO IT
		sleep 5
		ifconfig eth1 0 up
		brctl addbr br0
		brctl addif br0 eth1
		brctl addif br0 tap0
		ifconfig tap0 0
		ifconfig br0 172.16.56.1 netmask 255.255.255.0 up
		iptables -t nat -A POSTROUTING -s 172.16.0.0/16 -d 172.16.56.0/24 -o br0 -j SNAT --to 172.16.56.1
		iptables -t nat -A POSTROUTING -s 172.16.0.0/16 -d 192.168.9.0/24 -o br0 -j SNAT --to 172.16.56.1
		iptables -t nat -A POSTROUTING -s 172.16.56.0/24 -d 172.16.0.0/16 -o eth0 -j SNAT --to 172.16.51.243
		ip route add 192.168.9.0/24 via 172.16.56.3
		exit 0
	fi
	if [ "$TAP_ON" != "0" ] && [ "$BR_ON" != "0" ];
	then
		echo WAIT
		sleep 5
	fi
	if [ "$TAP_ON" == "0" ] && [ "$BR_ON" == "0" ];
	then
		echo HAVE DONE
		exit 1
	fi
done
