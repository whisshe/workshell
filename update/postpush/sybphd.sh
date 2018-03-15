#!/bin/bash
TIME=`cat ~/postpush/time/sdmjhd.time|tail -n 1`
sybphome=/home/game/sybp
PATH=/home/game/.nvm/versions/node/v7.6.0/bin:/usr/local/node/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games

cd $sybphome/sybphd
./stop.sh
cd $sybphome
rm sybphd -fr
ln -s ~/Rollback/server/sybphd-$TIME ./sybphd
ln -s ~/Rollback/server/sybp/gamelogs ./sybphd/gamelogs
ln -s ~/Rollback/server/sybp/start.sh ./sybphd/start.sh
ln -s ~/Rollback/server/sybp/stop.sh ./sybphd/stop.sh
cd sybphd
./start.sh


PORT_COUNT=`netstat -lpnt | grep 6101 | wc -l`
if [ $PORT_COUNT -lt 1 ]; then
    echo "邵阳剥皮后端启动失败"
    exit 1
else
    echo "邵阳剥皮后端启动成功"
fi

#将更新文件写入日志
for file in $files;do
echo $file--`date` >> deploy.log
done
exit 0
