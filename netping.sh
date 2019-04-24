#!/bin/bash
# FileName:netping.sh 
# DATE: 2019-04-24
# Author: Balich
# DESC: ping 指定网段内IP地址，打印出IP的状态


# 要检查的IP网段
SUBIP="10.80.210"

while true;do
    for ip in {0..255};do
        ping -c 2 -w 2 ${SUBIP}.${ip} &> /dev/null
        if [ $? -eq 0 ]; then
            echo -e "\033[32;40m ${SUBIP}.${ip} is UP. \033[0m"
        else
            echo -e "\033[31m ${SUBIP}.${ip} is DOWN. \033[0m"
        fi
    done
        break
done
