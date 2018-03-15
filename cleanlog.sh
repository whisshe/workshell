#!/bin/bash
##测试  清理7天之前的日志
a=`\ls ~/logs|wc -l`
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
for i in `\ls |awk -F_ '{print $2}' |grep -v log|uniq`;do
    if [ $i -lt $delday ];then
	echo $i >> a.i
	rm ~/logs/*$i* 
    fi
done
