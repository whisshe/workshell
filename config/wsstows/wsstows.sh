#!/bin/bash
#一键替换模板wsstows配置文件为所需域名
cd /etc/nginx/sites-available
rm *-wss*
rm ../sites-enabled/*-wss*
pwd=`pwd`

###替换域名
domain(){
	sed -i "s/cert-temp/$1/g" $pwd/$2
#	sed -i "s/domain/$3/g" $pwd/$2
}
wss-m(){
	sed -i "s/6002/$1/g"  $pwd/$2
}
ws-m(){
	sed -i "s/6001/$1/g"  $pwd/$2
}


cat config|while read line;do
	name=`echo $line |awk '{print $1}'`
	wss=`echo $line|awk '{print $2}'`
	ws=`echo $line|awk '{print $3}'`
	echo -e "\033[32m$name $wss wss config making\033[0m"
	nginxconf=$name-wss.pkgame.net.conf
	ngcfgCount=`ls |grep $nginxconf|wc -l`
	cp $pwd/cert-temp $pwd/$nginxconf.$ngcfgCount
	domain $name $nginxconf.$ngcfgCount $name.pkgame.net
	wss-m $wss $nginxconf.$ngcfgCount
	ws-m $ws $nginxconf.$ngcfgCount
	cd ../sites-enabled
	ln -s ../sites-available/$nginxconf.$ngcfgCount ./
done
/etc/init.d/nginx reload
