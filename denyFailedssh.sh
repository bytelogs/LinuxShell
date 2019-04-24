#!/bin/bash
# Filename: denyFailedssh.sh
# Author: Balich
# DESC: SSH 登录失败超过定义的次数后，禁止该IP访问SSH
# 将脚本加入到任务计划：echo "*/3 * * * * /bin/bash /usr/local/sbin/denyFailedssh.sh >> /var/spool/cron/root"


SECLOGS=/var/log/secure
FAILEDFILE=/tmp/failedssh.txt
FAILEDNUM=2

cat ${SECLOGS}|awk '/Failed password/{print $(NF-3)}'|sort|uniq -c|awk '{print $2"="$1;}' > ${FAILEDFILE}

for i in `cat ${FAILEDFILE}`
do
    IPADDR=`echo | awk '{split("'${i}'", array, "=");print array[1]}'`
    NUM=`echo | awk '{split("'${i}'", array, "=");print array[2]}'`
    if [ $NUM -gt $FAILEDNUM ];then
        grep $IPADDR /etc/hosts.deny > /dev/null
        if [ $? -gt 0 ];then
            echo "sshd:$IPADDR:deny" >> /etc/hosts.deny
        fi
    fi
done
