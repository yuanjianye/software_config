#!/usr/bin/expect
spawn ssh 182.254.161.98 -l root
expect "password:"
send "Jiawu6535\r"
interact
