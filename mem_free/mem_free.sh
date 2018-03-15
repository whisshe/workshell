#!/bin/bash
#内存剩余小于1.5G时，清理cache和buffer
mem_free=$(free -m |awk 'NR==2{print $4}')

if [ $mem_free  -lt 300 ];then
    sync
    echo $mem_free > /tmp/mem_free_before
    sleep 10
    echo 1 > /proc/sys/vm/drop_caches
    sleep 10
    mem_free_now=$(free -m |awk 'NR==2{print $4}')
    echo "after clean  $mem_free_now-----`date +%Y%m%d-%H%M`" >> /tmp/mem_free
    exit 0
fi
