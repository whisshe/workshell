#!/bin/bash
#一键替换模板wsstows配置文件为所需域名
shdir=`pwd`
cd /etc/nginx/sites-available
pwd=`pwd`

###替换域名
domain(){
	sed -i "s/cert-temp/$1/g" $pwd/$2
}
###从config里面读取要替换的配置
wss-m(){
	sed -i "s/8641/$2/g"  $pwd/$1
	sed -i "s/8642/$3/g"  $pwd/$1
	sed -i "s/8643/$4/g"  $pwd/$1
}
ws-m(){
	sed -i "s/4014/$2/g"  $pwd/$1
	sed -i "s/8524/$3/g"  $pwd/$1
	sed -i "s/8525/$4/g"  $pwd/$1
}


cat $shdir/config|while read line;do
	name=`echo $line |awk '{print $1}'`
	wss1=`echo $line|awk '{print $2}'`
	wss2=`echo $line|awk '{print $3}'`
	wss3=`echo $line|awk '{print $4}'`
	ws1=`echo $line|awk '{print $5}'`
	ws2=`echo $line|awk '{print $6}'`
	ws3=`echo $line|awk '{print $7}'`
	echo -e "\033[32m$name $wss wss config making\033[0m"
	nginxconf=$name-wss.pkgame.net.conf
	ngcfgCount=`ls |grep $nginxconf|wc -l`
##确保不重复生成文件,防止配置被覆盖
        [ -f $pwd/$nginxconf.$ngcfgCount ]||cp $shdir/cert-temp $pwd/$nginxconf.$ngcfgCount
	domain $name $nginxconf.$ngcfgCount $name.pkgame.net
	wss-m  $nginxconf.$ngcfgCount $wss1 $wss2  $wss3
	ws-m  $nginxconf.$ngcfgCount  $ws1 $ws2 $ws3
	cd ../sites-enabled
	ln -s ../sites-available/$nginxconf.$ngcfgCount ./
done
/etc/init.d/nginx reload
