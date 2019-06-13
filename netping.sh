#!/bin/bash
# FileName:netping.sh 
# DATE: 2019-04-24
# Author: Balich
# DESC: ping 指定网段内IP地址，打印出在线的IP状态并写入到文件
#       使用多线程


# 要检查的IP网段
SUBIP="10.80.210"

for ip in {0..255};do
    {
    ping -c 2 -w 2 ${SUBIP}.${ip} > /dev/null && echo ${SUBIP}.${ip}|tee -ai upip.log
    } &
done
wait


