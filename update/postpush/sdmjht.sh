#!/bin/bash
TIME=`cat ~/postpush/time/sdmjqd.time|tail -n 1`
cd /home/game
rm front -fr                                                            
ln -s ~/Rollback/client/sdmjqd-$TIME ./front                                    
cd front

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
