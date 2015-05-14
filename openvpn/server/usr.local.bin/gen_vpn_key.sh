#!/bin/bash
if [ "$1" != "" ];
then
	cd /etc/openvpn/easy-rsa/2.0
	source vars
	export KEY_NAME=$1
	./pkitool $1
	pack_vpn_key.sh $1	
fi
