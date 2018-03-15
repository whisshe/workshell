#!/bin/bash
#password list format : host  username  newpasswd time
P=/home/deploy/config_dep/changePass
Pfile=$P/Pass
Date=`date +%Y%m%d`
RH=`cat $P/roothost`
GH=`cat $P/gamehost`
#user=root
#-------------------------last version 20171025
echo -e "\033[31m "
read -p"which user'passwd  do you want to change: " user
echo -e "\033[0m"
if [ $user == root ];then       
    echo -e "\033[33m下面的主机的root密码将被更新，请确认\033[0m"
    echo -e "\033[31m$RH\033[0m"
    read -p "\033[31myes/no:\033[0m " answer
    if [ $answer == yes ];then
        for Host in $RH;do
                export user
                export Host
                mkpasswd  $Host > $Pfile
                NEWpass=`cat $Pfile`
                echo "$Host $user $NEWpass $Date" >> $P/Host_Pass 
        	echo -e "当前主机:\033[31m$Host\033[0m"
        	ssh $user@$Host "echo $user:$NEWpass|/usr/sbin/chpasswd"
        	if [ $? -eq 0 ];then
                        bash $P/repleace.sh
        		echo -e "\033[32m$Host change root'passwd success\033[0m"
        	else
        		echo -e "\033[31m$Host change root'passwd failed\033[0m"
        	fi
        done
    else 
        echo "退出密码更新"
    fi
elif [ $user == game ];then
    echo -e '\033[36m下面的主机的game密码将被更新，请确认\033[0m'
    echo $GH
    read -p "yes/no: " answer
    if [ $answer == yes ];then
        for Host in $GH;do
                export user
                export Host
                mkpasswd  $Host > $Pfile
                NEWpass=`cat $Pfile`
                echo "$Host $user $NEWpass $Date" >> $P/Host_Pass 
        	echo "当前主机:$Host"
        	ssh root@$Host "echo $user:$NEWpass|/usr/sbin/chpasswd"
        	if [ $? -eq 0 ];then
                        bash $P/repleace.sh
        		echo -e "\033[32m$Host change game'passwd success\033[0m"
        	else
        		echo -e "\033[31m$Host change game'passwd failed\033[0m"
        	fi
        done
    else 
        echo "退出密码更新"
    fi
else 
echo -e "\033[31m暂时只支持root和game用户\033[0m"
fi
