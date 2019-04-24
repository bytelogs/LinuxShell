#!/bin/bash
# FileName: mysqlbak.sh 
# DATE: 2019-04-24
# Author: Balich
# DESC: 使用mysqldump 备份MySQL数据库

# source function library.
. /etc/init.d/functions


HOST='127.0.0.1'
USERNAME='root'
PASSWORD='123'
PORT=3306
BASEDIR=/usr/local/mysql
BACKUPDIR=/data/backup
DATABASES=mydb
CURDAY=$(date '+%Y%m%d-%H%M')
SLAVEDAY=15
LOGDIR=${BACKUPDIR}/logs
LOGFILE=${LOGDIR}/${CURDAY}.log

checkOK(){
    if [ $? -ne 0 ];then
    echo "命令执行出现异常，请检查..."
    exit 10
    fi
}

backup(){
    echo -e "current time is : $(date '+%Y-%m-%d %H:%M:%S')"
    echo -e "[$(date '+%Y-%m-%d %H:%M:%S')] -- Starting backup MySQL databases ..."
    echo -e "[$(date '+%Y-%m-%d %H:%M:%S')] -- Backup file to ${BACKUPDIR}/${DATABASES}-${CURDAY}.gz"
    ${BASEDIR}/bin/mysqldump -h${HOST} -u${USERNAME} -p${PASSWORD} ${DATABASES} --single-transaction --flush-logs --set-gtid-purged=OFF |gzip > ${BACKUPDIR}/${DATABASES}-${CURDAY}.gz

    [ "$?" -eq "0" ] && echo "[$(date '+%Y-%m-%d %H:%M:%S')] -- 命令执行成功" || echo "[$(date '+%Y-%m-%d %H:%M:%S')] -- 命令执行异常 "

}


delfile(){
    # 清理指定日期文件
    echo -e "[$(date '+%Y-%m-%d %H:%M:%S')] -- Delete the ${SLAVEDAY} days ago backup file"
    find ${BACKUPDIR}/ -mtime +${SLAVEDAY} -exec ls {} \;
    find ${BACKUPDIR}/ -mtime +${SLAVEDAY} -exec rm -rf {} \;
}


run(){
    # 目录不存在则创建
    [ ! -d ${LOGDIR} ] && mkdir -p ${LOGDIR} 
    backup |tee -a ${LOGFILE}
    echo -e "\n"
    delfile|tee -a ${LOGFILE}
}

# 执行脚本
run




