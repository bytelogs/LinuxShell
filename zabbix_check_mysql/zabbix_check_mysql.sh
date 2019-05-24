#!/bin/bash
# -------------------------------------------------------------------------------
# FileName: zabbbix_check_mysql.sh
# Revision: 1.0
# -------------------------------------------------------------------------------
# Copyright: License: GPL
#
# DESC: MySQL5.7 命令行上带密码会提示："[Warning] Using a password on the command line interface can be insecure"的错误提示
#       使用 错误重定向 2>/dev/null 屏蔽掉。

# USER: 在zabbix上添加自定义监控项目
#       UserParameter=mysql.status[*],/bin/bash /var/lib/zabbix/check_mysql.sh $1
# 最后在zabbix web 上添加模板

export PATH=/usr/local/mysql/bin:$PATH


# MySQL name
MYSQL_USER='zabbix'

# MySQL password
MYSQL_PWD='zabbix123.'

# MySQL host or IP
MYSQL_HOST='127.0.0.1'

# MySQL PORT
MYSQL_PORT='3306'

# MySQL conn
MYSQL_CONN="mysqladmin -u${MYSQL_USER} -p${MYSQL_PWD} -h${MYSQL_HOST} -P${MYSQL_PORT}"
#MYSQL_CONN="mysqladmin --login-path=zabbix"

# MySQL
#MYSQL="mysql -u${MYSQL_USER} -p${MYSQL_PWD} -h${MYSQL_HOST} -P${MYSQL_PORT}"
MYSQL="mysql --login-path=zabbix"

# 参数是否正确
if [ $# -ne "1" ];then
    echo "arg error!"
fi

# 获取数据
case $1 in
    Uptime)
    result=`${MYSQL_CONN} status 2>/dev/null|cut -f2 -d":"|cut -f1 -d"T"`
    echo $result|awk '{print $NF}'
    ;;
Com_update)
    result=`${MYSQL_CONN} extended-status 2>/dev/null|grep -w "Com_update"|cut -d"|" -f3`
    echo $result|awk '{print $NF}'
    ;;
Slow_queries)
    result=`${MYSQL_CONN} status 2>/dev/null|cut -f5 -d":"|cut -f1 -d"O"`
    echo $result|awk '{print $NF}'
    ;;
Com_select)
    result=`${MYSQL_CONN} extended-status 2>/dev/null|grep -w "Com_select"|cut -d"|" -f3`
    echo $result|awk '{print $NF}'
    ;;
Com_rollback)
    result=`${MYSQL_CONN} extended-status 2>/dev/null|grep -w "Com_rollback"|cut -d"|" -f3`
    echo $result|awk '{print $NF}'
    ;;
Questions)
    result=`${MYSQL_CONN} status 2>/dev/null|cut -f4 -d":"|cut -f1 -d"S"`
    echo $result|awk '{print $NF}'
    ;;
Com_insert)
    result=`${MYSQL_CONN} extended-status 2>/dev/null|grep -w "Com_insert"|cut -d"|" -f3`
    echo $result|awk '{print $NF}'
    ;;
Com_delete)
    result=`${MYSQL_CONN} extended-status 2>/dev/null|grep -w "Com_delete"|cut -d"|" -f3`
    echo $result|awk '{print $NF}'
    ;;
Com_commit)
    result=`${MYSQL_CONN} extended-status 2>/dev/null|grep -w "Com_commit"|cut -d"|" -f3`
    echo $result|awk '{print $NF}'
    ;;
Bytes_sent)
    result=`${MYSQL_CONN} extended-status 2>/dev/null|grep -w "Bytes_sent" |cut -d"|" -f3`
    echo $result|awk '{print $NF}'
    ;;
Bytes_received)
    result=`${MYSQL_CONN} extended-status 2>/dev/null|grep -w "Bytes_received" |cut -d"|" -f3`
    echo $result|awk '{print $NF}'
    ;;
Com_begin)
    result=`${MYSQL_CONN} extended-status 2>/dev/null|grep -w "Com_begin"|cut -d"|" -f3`
    echo $result|awk '{print $NF}'
    ;;
ping)
    result=`${MYSQL_CONN} ping 2>/dev/null |grep -c alive`
    echo $result
    ;;
version)
    result=`${MYSQL} -V 2>/dev/null`
    echo $result
    ;;

*)
    echo "Usage:$0(Uptime|Com_update|Slow_queries|Com_select|Com_rollback|Questions|Com_insert|Com_delete|Com_commit|Bytes_sent|Bytes_received|Com_begin|ping|version)"
    ;;
esac