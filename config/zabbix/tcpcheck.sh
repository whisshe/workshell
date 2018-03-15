#!/bin/bash
cd ./tcp-check/
./ahost
cd ../
rsync -avu ./tcp-check/host root@www:/tmp/ 2>&1 >  /dev/null
rsync -avu ./tcp-check/ahost.txt root@www:/tmp/ 2>&1 >  /dev/null
sleep 1
ansible -i ./tcp-check/wwwhost -u root WWW -m shell -a "/tmp/host.sh"
ansible -i ./tcp-check/wwwhost -u root WWW -m shell -a "/zabbix/test/bin/tcpcheck.sh"
