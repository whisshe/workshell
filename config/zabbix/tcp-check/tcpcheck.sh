#!/bin/bash
###检测获取agent状态
H=`cat /tmp/host`
for B in $H
do
	for C in established listen
	do
		A=`/zabbix/test/bin/zabbix_get -s $B -k tcp.status[$C] `
		echo "$B的$C的状态为$A"
	done
done
