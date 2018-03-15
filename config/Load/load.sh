#!/bin/bash
# system load

case $1 in
    start)
        while true;do 
            pidstat -l |awk 'NR==3{print $1,$7,$3,$9}NR>3{if ($7 > 1)print $1,$7,$3,$9}' >> /var/log/load_`date +%Y%m%d`.log
            Date=`date +%Y%m%d`
            DelDate=$((Date - 2))
            rm /var/log/load_$DelDate.log -f
            #日志格式为时间-负载百分比-进程名
	    sleep 2
        done 
    ;;
    stop)
        /bin/kill -9 `pgrep load` 
    ;;
    restart)
        /bin/kill -9 `pgrep load`
        while true;do 
            pidstat -l |awk 'NR==3{print $1,$7,$3,$9}NR>3{if ($7 > 1)print $1,$7,$3,$9}' >> /var/log/load_`date +%Y%m%d`.log
            Date=`date +%Y%m%d`
            DelDate=$((Date - 2))
            rm /var/log/load_$DelDate.log -f
	    sleep 2
        done 
    ;;
    *)
        echo "start|stop|restart"
    ;;
esac
