<?php
    echo $_SERVER['REMOTE_ADDR']; 
    echo " ";
    system(" grep 'home IN' /etc/bind/yuanjianye.com.zone |awk '{print $4}' ");
?>
