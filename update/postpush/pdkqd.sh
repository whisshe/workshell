#!/bin/bash
TIME=`cat ~/postpush/time/pdkqd.time|tail -n 1` 
pdkhome=/home/game/fastrun-release
rm $pdkhome/web-server -fr      
ln -s ~/Rollback/client/pdkqd-$TIME ./web-server 
cd $pdkhome/web-server

cd /home/game/fastrun-release/web-server

files=$(find ./ -mmin -5 -type f)
filenumber=$(find ./ -mmin -5 -type f | wc -l)

if [ $filenumber -lt 20 ]; then
    echo "更新的文件列表..."
    echo $files
else
    echo -n "更新的文件个数. "
    echo $filenumber
fi

#将更新文件写入日志
for file in $files;do
echo $file--`date` >> deploy.log
done
exit 0
