#!/bin/bash
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin
cd /tmp/
mkdir myddns
cd myddns
wget http://182.254.161.98/ddns -o /dev/null 
if [ "$?" == "0" ];
then
     MY_IP=`cat ddns|awk '{print $1}'`
     HOME_IP=`cat ddns|awk '{print $2}'`
     if [ "$MY_IP" != "" ] && [ "$HOME_IP" != "" ];
     then
         #echo "my ip is $MY_IP"
         #echo "home ip is $HOME_IP"
         if [ "$MY_IP" != "$HOME_IP" ];
         then
             echo "do renew script"
             ssh www.yuanjianye.com "renew_ddns.sh $MY_IP"
         fi
     else
         echo "file unexpect" >&2
     fi
else 
    echo "wget error" >&2
fi
rm -r /tmp/myddns
date >>/tmp/ddns.log
