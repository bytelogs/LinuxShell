#!/bin/bash
# 
# FileName: scp-id-pub-key.sh
# DATE: 2019-06-13
# Author: Balich
# DESC: 将当前用户下的公钥(id_rsa.pub)拷贝到远程主机
# yum install expect -y

## 远程主机列表,一行一台主机IP或者主机名
HOSTLIST="
10.80.210.110
"
## 远程主机用户
USER="root"
## 远程主机用户密码
PASSWD="root"

## 自动交互执行程序
for HOST in $HOSTLIST;do
/usr/bin/expect << EOF
spawn ssh-copy-id $USER@$HOST
expect {
"yes/no" {send "yes\r"}
}
expect {
"password:" {send "$PASSWD\r"}
}
expect eof
EOF
done

