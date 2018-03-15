#!/bin/bash
##同步监控项到不同的机器
localdir=/home/deploy/config_dep/zabbix/moniShell
remotedir=/zabbix/scripts
sh=mem_free
function sync() {
    scp $localdir/$1 root@$2:$remotedir/
}
#用写好的sync  function 将脚本传送到指定的机器的指定目录下
for agent in `cat hosts|awk 'NR>1{print}'`;do
    sync $sh.sh $agent
done
status=`ansible -i hosts -u root Agent -m shell -a "cat /etc/zabbix/zabbix_agentd.conf|grep "UserParameter=$sh,/zabbix/scripts/$sh.sh"|wc -l"|awk 'NR==2{print}'`
if [ ${status} -lt 1 ];then
    ansible -i hosts -u root Agent -m shell -a "echo "UserParameter=$sh,/zabbix/scripts/$sh.sh" >> /etc/zabbix/zabbix_agentd.conf;/etc/init.d/zabbix-agent restart"
else
    echo -e "\033[31mAgent has Already added conf\033[0m"
fi
