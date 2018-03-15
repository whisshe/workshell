#!/bin/bash
##同步tcp-status
for A in apia apix gamea gameb gamec gamed servicea 
do
rsync -avu /home/deploy/config_dep/zabbix/agent_dep/tcp-status.sh root@$A:/zabbix/scripts/
	if [ $? -eq 0 ];then
	echo "$A success"
	fi
done
