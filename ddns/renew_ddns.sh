regex_ip="^(2[0-4][0-9]|25[0-5]|1[0-9][0-9]|[1-9]?[0-9])(\.(2[0-4][0-9]|25[0-5]|1[0-9][0-9]|[1-9]?[0-9])){3}$"
echo $1|grep -E "$regex_ip"
if [ "$?" == "0" ];then
    IP_NOW=`grep 'home IN' /etc/bind/yuanjianye.com.zone|awk '{print $4}'`
    sed -i "s/$IP_NOW/$1/g" "/etc/bind/yuanjianye.com.zone" 
    service bind9 restart
else
    echo $1 is not a ip address
    exit
fi

