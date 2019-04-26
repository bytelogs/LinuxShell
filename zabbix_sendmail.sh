#!/bin/bash
# Filename: zabbix_sendmail.sh
# Author: Balich
# DESC: zabbix 告警发送邮件脚本
# 在http://caspian.dotconf.net/menu/Software/SendEmail/ 下载SendEmail 使用


# SMTP服务器
SMTP_server='smtp.163.com'   
# 用户名
username='username@163.com' 
# 密码
password='password.'
# 发件人Email地址
from_email_address='username@163.com'
# 收件人Email地址，zabbix传入的第一个参数
to_email_address="$1"
# 邮件标题，zabbix传入的第二个参数
message_subject_utf8="$2"
# 邮件内容，zabbix传入的第三个参数
message_body_utf8="$3"  

# 转换邮件标题为GB2312，解决邮件标题含有中文，收到邮件显示乱码的问题。
message_subject_gb2312=iconv -t GB2312 -f UTF-8 << EOF
$message_subject_utf8
EOF

[ $? -eq 0 ] && message_subject="$message_subject_gb2312" || message_subject="$message_subject_utf8"

# 转换邮件内容为GB2312
message_body_gb2312=iconv -t GB2312 -f UTF-8 << EOF
$message_body_utf8
EOF

[ $? -eq 0 ] && message_body="$message_body_gb2312" || message_body="$message_body_utf8"

# 发送邮件
sendEmail='/usr/local/bin/sendEmail'
$sendEmail -s "$SMTP_server" -xu "$username" -xp "$password" -f "$from_email_address" -t "$to_email_address" -u "$message_subject" -m "$message_body" -o message-content-type=text -o message-charset=gb2312


