#!/bin/bash
#检测dropcache恢复0的时间
A=`cat /proc/sys/vm/drop_caches`
date=`date`
if [ $A -eq 0 ];then
    echo $date >> /tmp/drop
fi
