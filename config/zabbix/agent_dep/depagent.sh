#!/bin/bash
##部署agent配置
Machine=`cat /home/deploy/config_dep/zabbix/agent_dep/hosts|grep -v "\["`
S=/home/deploy/config_dep/zabbix/agent_dep/
for H in $Machine
do
	rsync -avu --delete $S/agent*   root@$H:/tmp/
	sleep 1
	ansible  -i ./hosts  -u root Agent  -m shell -a "/tmp/agentpurge.sh" 
	sleep 2
	ansible  -i ./hosts  -u root Agent  -m shell -a "/tmp/agent.sh" 
	sleep 1
	rsync -avu $S/tcp-status.sh   root@$H:/zabbix/scripts/ ||echo "rsync failed"
	ansible -i ./wwwhost -uroot WWW  -a "/zabbix/test/bin/tcpcheck.sh"
if [ $? -eq 0 ];then
	echo -e "\033[34m$H dep succuss!!\033[0m"
	echo $H >> ../tcp-check/host
	sed -i /$H/d ./hosts
else
	echo "ansible failed"
fi
done

