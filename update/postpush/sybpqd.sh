#!/bin/bash
TIME=`cat ~/postpush/time/sybpqd.time|tail -n 1`                                   
sybphome=/home/game/sybp
rm $sybphome/sybpqd -fr                                                            
ln -s ~/Rollback/client/sybpqd-$TIME ./sybpqd                                      
cd $sybphome/sybpqd

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
