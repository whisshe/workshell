#!/bin/bash
##正式服  清理7天之前的日志
serverdir=/home/game/Rollback/server
##################logs####################
function logsClean() {
a=`\ls $serverdir/$1/logs|wc -l`
today=`date +%Y%m%d`
d=`date +%d`
m=`date +%m`
if [ $d -lt 7 ];then 
    if [ $m -eq 1 ];then
	delday=$((today - 8877))
    else
        delday=$((today - 77))
    fi
else
    delday=$((today - 7))
fi 
cd $serverdir/$1/logs
for i in `\ls |awk -F_ '{print $4}'|awk -F. '{print $1}'|sort -u`;do
    if [ $i -lt $delday ];then
	echo $i >> logs.i
	rm $serverdir/$1/logs/log_*${i}.log 
    fi
done
}
logsClean sdmj
logsClean sybp
##################gamelogs####################
function gamelogsClean() {
today=`date +%Y%m%d%H%M%S`
d=`date +%d`
m=`date +%m`
if [ $d -lt 7 ];then 
    if [ $m -eq 1 ];then
	delday=$((today - 8877000000))
    else
        delday=$((today - 77000000))
    fi
else
    delday=$((today - 7000000))
fi 
cd $serverdir/$1/gamelogs
for g in `\ls |awk -F_ '{print $3}' |sort -u`;do
    if [ $g -lt $delday ];then
	echo $g >> gamelogs.i
	rm $serverdir/$1/gamelogs/*${g}* 
    fi
done
}
gamelogsClean sdmj
gamelogsClean sybp
#删除sdmj数据库game_log表的7天之前的数据
today=`date +%Y%m%d`
delday=$((today -7))
mysql -uroot -pvpi\*\#\&287Viif@ -e "
use game
delete from game_log where time < '$delday';
use sybp
delete from game_log where time < '$delday';
quit "

exit 0
