#!/bin/bash
hostname > /tmp/name
N=`cat /tmp/name`
apt-get install zabbix-agent -y
sleep 1
	if [ $? -eq 0 ];then
		mkdir -p /zabbix/scripts
		sed -i 's/Server=127.0.0.1/Server=172.18.254.245/g' /etc/zabbix/zabbix_agentd.conf
		sed -i 's/ServerActive=127.0.0.1/ServerActive=172.18.254.245/g' /etc/zabbix/zabbix_agentd.conf
		echo "UserParameter=tcp.status[*],/zabbix/scripts/tcp-status.sh \$1" >> /etc/zabbix/zabbix_agentd.conf
		sed -i "s/Hostname=Zabbix server/Hostname=$N/g" /etc/zabbix/zabbix_agentd.conf
		sleep 1
		service zabbix-agent restart 
	else
        	echo "failed"
	fi
