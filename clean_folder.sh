#!/bin/bash
# Filename: clean_folder.sh
# Author: Balich
# DESC: 用于清理指定目录下的目录数量，保留设定的值的数量



PACKAGE_DIR=/opt/linux/packages
PROJECT_NAME=application

echo -e "当前项目是：$PROJECT_NAME"

# 远程主机保留WAR包目录格式
RESERVED_NUM=5

CLEAN_FILE(){
    Folder_num=$(ls -l ${PACKAGE_DIR}/${PROJECT_NAME}|grep ^d |wc -l)
    while(( $Folder_num > $RESERVED_NUM ))
    do
        OldFolder=$(ls -rt ${PACKAGE_DIR}/${PROJECT_NAME}|head -1)
        echo -e "${PACKAGE_DIR}/${PROJECT_NAME}/$OldFolder"
        rm -rf ${PACKAGE_DIR}/${PROJECT_NAME}/$OldFolder
        let "Folder_num--"
    done
}


echo -e "删除目录"
CLEAN_FILE
