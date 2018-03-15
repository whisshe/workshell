#!/bin/bash
#删除sdmj数据库game_log表的7天之前的数据
today=`date +%Y%m%d`
delday=$((today -7))
mysql -uroot -p123123 -e "
use sdmj
delete from game_log where time < '$delday';
quit "

exit 0
