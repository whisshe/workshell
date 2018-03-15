#!/bin/bash
status=$(cat /tmp/cron-st)
if [ $status -lt 1 ];then 
    echo "*/15 * * * * /tmp/mem_free.sh" >> /var/spool/cron/crontabs/root
    exit 0
else 
    echo -e "\033[31mcrontab is already added\033[0m"
    exit 0
fi
