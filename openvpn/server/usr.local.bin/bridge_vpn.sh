ifconfig eth1 0 up
brctl addbr br0
brctl addif br0 eth1
brctl addif br0 tap0
ifconfig tap0
ifconfig br0 172.16.56.1 netmask 255.255.255.0 up

