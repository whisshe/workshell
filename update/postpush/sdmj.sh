#!/bin/bash

TIME=`cat ~/postpush/time/sdmjhd.time|tail -n 1`
PATH=/home/game/.nvm/versions/node/v7.6.0/bin:/usr/local/node/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games

cd /home/game/sdmj/
./stop.sh
cd /home/game
rm sdmj -fr
ln -s ~/Rollback/server/sdmjhd-$TIME ./sdmj
ln -s ~/Rollback/server/sdmj/logs ./sdmj/logs
ln -s ~/Rollback/server/sdmj/gamelogs ./sdmj/gamelogs
ln -s ~/Rollback/server/sdmj/start.sh ./sdmj/start.sh
ln -s ~/Rollback/server/sdmj/stop.sh ./sdmj/stop.sh
cd sdmj
./start.sh
sleep 3

PORT_COUNT=`netstat -lpnt | grep 6001 | wc -l`
if [ $PORT_COUNT -lt 1 ]; then
    echo "邵东麻将后端启动失败"
    exit 1
else
    echo "邵东麻将后端启动成功"
fi

#将更新文件写入日志
for file in $files;do
echo $file--`date` >> deploy.log
done
exit 0
