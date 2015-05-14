#!/bin/bash
if [ -f /etc/openvpn/keys/$1.crt ] && [ -f /etc/openvpn/keys/$1.csr ] && [ -f /etc/openvpn/keys/$1.key ];
then
	rm -rf /tmp/ovpn_tmp
	mkdir -p /tmp/ovpn_tmp/keys
	cp  /etc/openvpn/keys/$1* -a /tmp/ovpn_tmp/keys
	cp /etc/ovpn_client_tmp/* -a /tmp/ovpn_tmp
	sed -i "s/key_name/$1/g" /tmp/ovpn_tmp/client.conf
	cd /tmp/ovpn_tmp
	tar zcvf $1.tar.gz *
	mv $1.tar.gz /srv/ftp/openvpn_keys
	rm -rf /tmp/ovpn_tmp
else
	echo file not found
fi
